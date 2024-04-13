#!/bin/bash

# Start the Python server
echo "Starting Python server..."

cd python
python quantum.py & echo $! > python_server.pid

# Wait for the Python server to start
echo "Waiting for Python server to start..."

sleep 5
cd ..

# Start the Dart server
echo "Starting Dart server..."

dart bin/server.dart & echo $! > dart_server.pid

# Wait for the Dart server to start
echo "Waiting for Dart server to start..."

sleep 5