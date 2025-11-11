"""
Entrypoint shim for running the FastAPI app with uvicorn using 'main:app'.

This module exposes the FastAPI app instance imported from src.api.main.
Usage:
    uvicorn main:app --host 0.0.0.0 --port 3001

Alternatively, using the explicit module path:
    uvicorn src.api.main:app --host 0.0.0.0 --port 3001
"""

# PUBLIC_INTERFACE
from src.api.main import app  # noqa: F401

__all__ = ["app"]
