#!/bin/bash

#!/bin/bash

#PRUEBA
apt-get update
apt-get install  -y  libgl1-mesa-glx  libglib2.0-0
pip install  -r  requirements.txt
uvicorn main:app  --host  0.0.0.0  --port  8000

#PRUEBA

export NODE_OPTIONS=--max_old_space_size=8192

echo ""
echo "Restoring frontend npm packages"
echo ""
cd frontend
npm install
if [ $? -ne 0 ]; then
    echo "Failed to restore frontend npm packages"
    exit $?
fi

echo ""
echo "Building frontend"
echo ""
npm run build
if [ $? -ne 0 ]; then
    echo "Failed to build frontend"
    exit $?
fi

cd ..
. ./scripts/loadenv.sh

echo ""
echo "Starting backend"
echo ""
./.venv/bin/python -m quart run --port=50505 --host=127.0.0.1 --reload
if [ $? -ne 0 ]; then
    echo "Failed to start backend"
    exit $?
fi
