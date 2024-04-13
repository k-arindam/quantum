#!/bin/bash

# Stop the Python server
echo "Stopping Python server..."
kill $(cat python_server.pid) && rm python_server.pid

# Stop the Dart server
echo "Stopping Dart server..."
kill $(cat dart_server.pid) && rm dart_server.pid