#!/bin/bash
cd "$(dirname "$0")/../.." || exit 1
PORT=8081

echo "Close the browser window first if it is still open, then press Enter to stop the server."
read -r

if [ -f server.pid ]; then
  PID=$(cat server.pid)
  if kill -0 "$PID" 2>/dev/null; then
    echo "Stopping llamafile server (PID $PID)..."
    kill "$PID"
    rm -f server.pid
    echo "Stopped."
    exit 0
  fi
fi

echo "No active PID file found. Checking port $PORT directly..."
PORT_PID=$(lsof -ti tcp:$PORT)
if [ -n "$PORT_PID" ]; then
  echo "Found process $PORT_PID on port $PORT. Stopping it."
  kill "$PORT_PID"
  echo "Stopped."
else
  echo "Nothing is running on port $PORT."
fi
