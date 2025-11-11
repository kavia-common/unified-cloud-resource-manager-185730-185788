#!/bin/bash
cd /home/kavia/workspace/code-generation/unified-cloud-resource-manager-185730-185788/BackendAPIService
source venv/bin/activate
flake8 .
LINT_EXIT_CODE=$?
if [ $LINT_EXIT_CODE -ne 0 ]; then
  exit 1
fi

