"""Rebuild the public store-month extracts from the supplied teaching archive.

Usage: python scripts/prepare_data.py "path/to/source.zip"
Dependency: openpyxl
"""
import argparse
import csv
import io
import re
from collections import Counter, defaultdict
from datetime import date, datetime
from decimal import Decimal
from pathlib import Path
from zipfile import ZipFile

from openpyxl import load_workbook


def workbook(archive, path):
    return load_workbook(io.BytesIO(archive.read("DataSource Power BI/" + path)),
                         read_only=True, data_only=True)


def month_start(value):
    return date(value.year, value.month, 1).isoformat()


def write_csv(directory, name, headers, rows):
    with (directory / name).open("w", encoding="utf-8", newline="") as output:
        writer = csv.writer(output, lineterminator="\n")
        writer.writerow(headers)
        writer.writerows(rows)


def extract(archive, output):
    main = workbook(archive, "main file.xlsx")
    shops = {}
    for key, name, city, *_ in list(main["DimStore"].values)[1:]:
        if key is not None:
            shops[key] = (name.replace("Kiev", "Kyiv"), city.replace("Kiev", "Kyiv"))

    # Aggregate at store and calendar month before combining sales and budgets.
    # Each invoice can have several rows. Preserve all lines and count receipts once.
    sales = defaultdict(lambda: [Decimal(0), Decimal(0), 0, 0, set()])
    receipt_month = {}
    sources = Counter()
    day_counts = Counter()

    def add(shop, day, invoice, qty, amount, cost, source):
        if shop not in shops or not invoice or qty is None or cost is None or amount is None:
            raise ValueError(f"Incomplete sale in {source} at invoice {invoice}")
        month = month_start(day)
        key = (shop, str(invoice))
        if receipt_month.setdefault(key, month) != month:
            raise ValueError(f"Receipt spans months in {source}")
        row = sales[shop, month]
        row[0] += Decimal(str(amount))
        row[1] += Decimal(str(cost))
        row[2] += int(qty)
        row[3] += 1
        row[4].add(str(invoice))
        sources[source] += 1
        day_counts[day.date() if isinstance(day, datetime) else day] += 1

    for r in main["Sale"].iter_rows(min_row=2, values_only=True):
        if r[0] is not None:
            add(r[7], r[1], r[0], r[4], r[5], r[8], "Main workbook")

    for name in sorted(archive.namelist()):
        if name.endswith(".xlsx") and "/Sale Kiev/" in name:
            shop = 100 + int(re.search(r",(\d+)\.xlsx$", name).group(1))
            sheet = workbook(archive, name.split("DataSource Power BI/")[1]).worksheets[0]
            for r in sheet.iter_rows(min_row=2, values_only=True):
                if r[0] is not None:
                    add(shop, r[1], r[0], r[4], r[5], r[8], "Kyiv Excel")
        if name.endswith(".csv") and "/_Sale_Kharkiv/" in name:
            shop = 100 + int(Path(name).name.split("_")[0])
            rows = csv.reader(io.StringIO(archive.read(name).decode("cp1251")), delimiter=";")
            next(rows)
            for r in rows:
                if r and r[0].strip():
                    day = date(int(r[1]), int(r[2]), int(r[3]))
                    add(shop, day, r[0], r[5], r[7], r[9], "Kharkiv CSV")

    plan = workbook(archive, "Sales and cost price (plan).xlsx")
    grid = list(plan["sales plan"].values)
    months = [(i, month_start(d)) for i, d in enumerate(grid[2]) if isinstance(d, datetime)]
    # Network sales end in September. Q4 contains only seven December lines.
    # Keep a fixed historical window across ALL facts to compare like periods.
    print("Outside comparison window:", sum(count for d, count in day_counts.items() if d >= date(2022, 10, 1)))
    months = [(i, m) for i, m in months if "2020-01-01" <= m <= "2022-09-01"]
    widths = {r[0]: [r[i] for i, _ in months] for r in grid[3:] if r[0] in shops}
    sales = {k: v for k, v in sales.items() if "2020-01-01" <= k[1] <= "2022-09-01"}
    expected = {(s, m) for s in shops for _, m in months}
    if set(sales) != expected or set(widths) != set(shops) or any(
            v is None for values in widths.values() for v in values):
        raise ValueError("Sales or target coverage is incomplete.")

    costs = []
    for d, s, category, scenario, amount in list(main["Operating cost"].values)[1:]:
        if scenario == "факт" and (s, month_start(d)) in expected:
            costs.append((s, month_start(d), category, amount))
    if len(set((s, m, c) for s, m, c, _ in costs)) != len(costs):
        raise ValueError("Duplicate operating expense category in a store-month.")
    if set((s, m) for s, m, _, _ in costs) != expected:
        raise ValueError("Operating expense coverage is incomplete.")

    output.mkdir(parents=True, exist_ok=True)
    write_csv(output, "stores.csv", ["StoreID", "Store", "City"],
              [(k, *v) for k, v in sorted(shops.items())])
    write_csv(output, "sales.csv", ["StoreID", "Month", "Revenue", "ProductCost", "Units", "Lines", "Receipts"],
              [(s, m, round(a, 4), round(c, 4), q, n, len(ids))
               for (s, m), (a, c, q, n, ids) in sorted(sales.items())])
    write_csv(output, "targets.csv", ["StoreID"] + [m for _, m in months],
              [(s, *[round(Decimal(str(v)), 4) for v in row]) for s, row in sorted(widths.items())])
    monthly_expense = defaultdict(Decimal)
    for shop, month, _, amount in costs:
        monthly_expense[shop, month] += Decimal(str(amount))
    write_csv(output, "expenses.csv", ["StoreID", "Month", "Expense"],
              [(s, m, total) for (s, m), total in sorted(monthly_expense.items())])
    print(dict(sources), "store-months:", len(sales), "included receipts:", sum(len(r[4]) for r in sales.values()))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("archive", type=Path)
    parser.add_argument("--out", type=Path, default=Path(__file__).resolve().parents[1] / "data")
    args = parser.parse_args()
    with ZipFile(args.archive) as source:
        extract(source, args.out)
