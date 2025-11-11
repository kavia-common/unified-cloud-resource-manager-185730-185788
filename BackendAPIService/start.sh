#!/usr/bin/env bash
set -euo pipefail

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-3001}"
APP_MODULE="${APP_MODULE:-main:app}"
WORKERS="${WORKERS:-1}"
LOG_LEVEL="${LOG_LEVEL:-info}"
RELOAD="${RELOAD:-false}"

# Ensure working directory is the service root
cd "$(dirname "$0")"

# Ensure src is importable regardless of execution environment
export PYTHONPATH="${PYTHONPATH:-.}"

# Cleanup previous log if present
UVICORN_LOG="uvicorn.log"
: > "${UVICORN_LOG}"

# Build uvicorn command
UVICORN_CMD=(uvicorn "${APP_MODULE}" --host "${HOST}" --port "${PORT}" --log-level "${LOG_LEVEL}")
if [ "${RELOAD}" = "true" ]; then
  UVICORN_CMD+=(--reload)
else
  UVICORN_CMD+=(--workers "${WORKERS}")
fi

echo "Starting BackendAPIService with: ${UVICORN_CMD[*]}"
# Start uvicorn in background and redirect logs
set +e
"${UVICORN_CMD[@]}" > "${UVICORN_LOG}" 2>&1 &
UVICORN_PID=$!
set -e

# Function to print logs for diagnostics
print_logs() {
  echo "==== Uvicorn logs (last 200 lines) ===="
  tail -n 200 "${UVICORN_LOG}" || true
  echo "======================================="
}

# Wait for readiness
HEALTH_URL="${HEALTH_URL:-http://127.0.0.1:${PORT}/healthz}"
MAX_RETRIES="${MAX_RETRIES:-30}"
SLEEP_SECONDS="${SLEEP_SECONDS:-1}"

echo "Waiting for readiness at ${HEALTH_URL} (retries=${MAX_RETRIES}, sleep=${SLEEP_SECONDS}s)..."
for i in $(seq 1 "${MAX_RETRIES}"); do
  if curl -fsS "${HEALTH_URL}" > /dev/null 2>&1; then
    echo "Service is ready (attempt ${i})."
    exit 0
  fi

  # Check if process died
  if ! kill -0 "${UVICORN_PID}" > /dev/null 2>&1; then
    echo "Uvicorn process exited unexpectedly during startup."
    print_logs
    exit 1
  fi

  sleep "${SLEEP_SECONDS}"
done

echo "Service did not become ready after ${MAX_RETRIES} attempts."
print_logs

# Try to terminate uvicorn on failure
kill "${UVICORN_PID}" > /dev/null 2>&1 || true
sleep 1
kill -9 "${UVICORN_PID}" > /dev/null 2>&1 || true

exit 1
