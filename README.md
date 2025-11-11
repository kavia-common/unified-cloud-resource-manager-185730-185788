# unified-cloud-resource-manager-185730-185788

BackendAPIService - Running the FastAPI server

Quick start (recommended):
- From the BackendAPIService directory:
  ./start.sh
This will:
- Start uvicorn with main:app on 0.0.0.0:3001
- Wait for readiness by polling http://127.0.0.1:3001/healthz with retries
- Print uvicorn logs if startup fails and exit non-zero

Manual start:
1) Using the top-level shim:
   uvicorn main:app --host 0.0.0.0 --port 3001

2) Using the fully-qualified module path:
   uvicorn src.api.main:app --host 0.0.0.0 --port 3001

Notes:
- The FastAPI app instance lives in src/api/main.py as 'app = FastAPI()'.
- We've added src/__init__.py and src/api/__init__.py so module imports work.
- Ensure the working directory is BackendAPIService for module resolution, or set PYTHONPATH=. before running uvicorn/process managers.
- Health endpoints:
  - GET /          -> returns 200 and {"status":"ok","message":"Healthy"}
  - GET /healthz   -> returns 200 and {"status":"ok","ready":true}