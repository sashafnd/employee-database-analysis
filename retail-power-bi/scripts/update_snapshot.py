"""Copy regenerated public CSV extracts into the offline Power Query snapshot."""
import base64
import json
import zlib
from pathlib import Path


def update_snapshot(project):
    model_file = project / "Retail.SemanticModel" / "model.bim"
    document = json.loads(model_file.read_text(encoding="utf-8"))
    for query in document["model"]["expressions"]:
        stem = query["name"].removesuffix("Snapshot")
        content = (project / "data" / (stem + ".csv")).read_bytes()
        encoder = zlib.compressobj(level=9, wbits=-15)
        compressed = encoder.compress(content) + encoder.flush()
        query["expression"] = '"' + base64.b64encode(compressed).decode("ascii") + '"'
    model_file.write_text(json.dumps(document, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    update_snapshot(Path(__file__).resolve().parents[1])

