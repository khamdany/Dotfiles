#!/bin/bash

# 1. Define variables
ENV_DIR="/home/thinkpad/Program/python/env/"
SCRIPT_NAME="/home/thinkpad/Program/python/webdav.py"

# 2. Create virtual environment if it doesn't exist
if [ ! -d "$ENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv $ENV_DIR
fi

# 3. Activate and install dependencies
echo "Activating environment and checking dependencies..."
source $ENV_DIR/bin/activate
pip install --upgrade pip
pip install wsgidav cheroot

# 4. Run the WebDAV script
echo "Launching WebDAV server..."
python $SCRIPT_NAME
