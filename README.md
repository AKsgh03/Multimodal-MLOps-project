# Smart ML Project — MLOps Template (GitHub-Ready)

A complete, resume-ready MLOps project scaffold that demonstrates:
- **Data Ingestion** → **Preprocessing** → **Training** → **Evaluation**
- **Logging** via Python `logging` (YAML-configurable)
- **Experiment Tracking** with **MLflow**
- **Data & Pipeline Versioning** with **DVC**
- **UI** with **Streamlit** for quick demo
- **API** with **FastAPI** for deployment
- **Docker** & **CI** (GitHub Actions) for production hygiene
- **Testing**, **Linting**, and **Makefile** for developer ergonomics

> Uses a self-contained example (Iris dataset) so it runs offline. Swap the data source and model with your own project easily.

---

## Quickstart

```bash
# 1) Create & activate venv (recommended)
python -m venv .venv && source .venv/bin/activate  # (Windows: .venv\Scripts\activate)

# 2) Install deps
pip install --upgrade pip
pip install -r requirements.txt

# 3) Set up DVC (optional but recommended)
dvc init
dvc repro          # Builds the pipeline defined in dvc.yaml

# 4) Run MLflow UI (in another terminal)
mlflow ui --backend-store-uri mlruns --port 5001

# 5) Run Streamlit UI
make run-ui        # or: streamlit run ui/app.py

# 6) Run FastAPI (prediction server)
make run-api       # or: uvicorn src.serve.api:app --host 0.0.0.0 --port 8000
```

---

## Project Structure

```
.
├── configs/
│   ├── logging.yaml
│   └── params.yaml
├── data/                      # (DVC-tracked; created at runtime)
├── dvc.yaml
├── Makefile
├── models/                    # Saved models (artifacts)
├── notebooks/                 # Put EDA notebooks here
├── requirements.txt
├── src/
│   ├── common/
│   │   ├── logger.py
│   │   └── paths.py
│   ├── data/
│   │   ├── ingest.py
│   │   └── preprocess.py
│   ├── features/
│   │   └── build_features.py
│   ├── models/
│   │   ├── train.py
│   │   └── evaluate.py
│   ├── serve/
│   │   ├── api.py            # FastAPI server
│   │   └── predict.py
│   └── utils/
│       └── io.py
├── tests/
│   └── test_basic.py
├── ui/
│   └── app.py                 # Streamlit UI
├── Dockerfile
├── docker-compose.yaml
├── .github/workflows/ci.yml
└── README.md
```

---

## DVC Pipeline

```yaml
stages:
  ingest:
    cmd: python src/data/ingest.py --out data/raw.csv
    outs:
      - data/raw.csv

  preprocess:
    cmd: python src/data/preprocess.py --inp data/raw.csv --out data/processed.csv
    deps:
      - data/raw.csv
    outs:
      - data/processed.csv

  train:
    cmd: python src/models/train.py --inp data/processed.csv --model models/model.joblib
    deps:
      - data/processed.csv
      - configs/params.yaml
    outs:
      - models/model.joblib
    metrics:
      - outputs/metrics.json

  evaluate:
    cmd: python src/models/evaluate.py --inp data/processed.csv --model models/model.joblib --out outputs/report.json
    deps:
      - models/model.joblib
      - data/processed.csv
    outs:
      - outputs/report.json
```

---

## Swapping to Your Own Project

- Replace **ingest.py** to pull your data (S3/GCS/DB/HTTP).
- Adjust **preprocess.py** / **build_features.py** for your pipeline.
- Update **params.yaml** for hyperparams and training settings.
- Keep MLflow logging—your experiments will be tracked automatically.
- Use Streamlit UI to demo results and FastAPI to serve model predictions.

**Pro Tip:** Commit with DVC (`dvc add data/...`, set up a remote) to version large data & models.
