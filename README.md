# unified-cloud-resource-manager-185730-185788

BackendAPIService - Running the FastAPI server
- From the BackendAPIService directory, you can start the server in either of the following ways:

1) Using the top-level shim:
   uvicorn main:app --host 0.0.0.0 --port 3001

2) Using the fully-qualified module path:
   uvicorn src.api.main:app --host 0.0.0.0 --port 3001

Notes:
- The FastAPI app instance lives in src/api/main.py as 'app = FastAPI()'.
- We've added src/__init__.py and src/api/__init__.py so module imports work.
- If you use a process manager or container, ensure the working directory is BackendAPIService so these imports resolve correctly.