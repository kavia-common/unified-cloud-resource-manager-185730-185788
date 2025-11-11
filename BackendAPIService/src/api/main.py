from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

# Define OpenAPI tags for grouping
openapi_tags = [
    {"name": "Health", "description": "Service health and readiness checks."},
]

# Create the FastAPI app with metadata for docs
app = FastAPI(
    title="Cloud Manager Backend API",
    description="Backend API for the Cloud Manager application. Provides endpoints for managing cloud resources and system operations.",
    version="0.1.0",
    openapi_tags=openapi_tags,
)

# Allow CORS for all origins for now; can be restricted via env/config later
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# PUBLIC_INTERFACE
@app.get("/", tags=["Health"], summary="Root Health", description="Simple root endpoint for quick health verification without any dependencies.")
def health_root() -> JSONResponse:
    """Return a basic healthy response to indicate service is up."""
    return JSONResponse({"status": "ok", "message": "Healthy"}, status_code=200)


# PUBLIC_INTERFACE
@app.get(
    "/healthz",
    tags=["Health"],
    summary="Readiness probe",
    description="A dependency-free readiness check that returns 200 quickly.",
)
def healthz() -> JSONResponse:
    """Return 200 immediately to signal the service is ready."""
    return JSONResponse({"status": "ok", "ready": True}, status_code=200)
