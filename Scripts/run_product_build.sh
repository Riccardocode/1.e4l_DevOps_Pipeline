#!/bin/bash

# Define paths to the scripts
BACKEND_SCRIPT="$HOME/1.e4l_DevOps_Pipeline/Scripts/automate_backend_build.sh"
FRONTEND_SCRIPT="$HOME/1.e4l_DevOps_Pipeline/Scripts/automate_frontend_build.sh"
DATABASE_SCRIPT="$HOME/1.e4l_DevOps_Pipeline/Scripts/prepare_database.sh"

# Step 1: Run the backend build script
echo "Running backend build script..."
if bash "$BACKEND_SCRIPT"; then
    echo "Backend build script completed successfully."
else
    echo "Backend build script failed." >&2
    exit 1
fi

# Step 2: Run the frontend build script
echo "Running frontend build script..."
if bash "$FRONTEND_SCRIPT"; then
    echo "Frontend build script completed successfully."
else
    echo "Frontend build script failed." >&2
    exit 1
fi

# Step 3: Run the database preparation script
echo "Running database preparation script..."
if bash "$DATABASE_SCRIPT"; then
    echo "Database preparation script completed successfully."
else
    echo "Database preparation script failed." >&2
    exit 1
fi

echo "All scripts executed successfully."
