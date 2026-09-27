#!/bin/bash
cd "$(dirname "$0")/../.." || exit 1
PORT=8081
echo "Close the browser window first, then press Enter to stop the server."
read -r
if [ -f server.pid ]; then
  PID=$(cat server.pid)
  if kill -0 "$PID" 2>/dev/null; then
    kill "$PID"
    rm -f server.pid
    echo "Stopped."
    exit 0
  fi
fi
PORT_PID=$(lsof -ti tcp:$PORT 2>/dev/null || fuser $PORT/tcp 2>/dev/null)
if [ -n "$PORT_PID" ]; then
  kill "$PORT_PID"
  echo "Stopped."
else
  echo "Nothing running on port $PORT."
fi
