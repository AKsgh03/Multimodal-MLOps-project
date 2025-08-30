.PHONY: install format lint test run-ui run-api mlflow-ui dvc-init repro docker-build docker-run

install:
	pip install --upgrade pip
	pip install -r requirements.txt

format:
	black .
	isort .

lint:
	flake8 .

test:
	pytest -q

run-ui:
	streamlit run ui/app.py

run-api:
	uvicorn src.serve.api:app --host 0.0.0.0 --port 8000

mlflow-ui:
	mlflow ui --backend-store-uri mlruns --port 5001

dvc-init:
	dvc init

repro:
	dvc repro

docker-build:
	docker build -t mlops-project:latest .

docker-run:
	docker run -p 8000:8000 -p 8501:8501 mlops-project:latest
