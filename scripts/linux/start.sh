#!/bin/bash
cd "$(dirname "$0")/../.." || exit 1
LLAMAFILE="llamafile-0.10.6"
MODEL="dolphin-2.9.4-llama3.1-8b-Q4_K_M.gguf"
PORT=8081
PROFILE="$PWD/browser-profile"
chmod +x "$LLAMAFILE" 2>/dev/null
mkdir -p "$PROFILE"

echo "Starting server on port $PORT from $PWD"
echo "To stop later, run scripts/linux/stop.sh from the repo root."

(
  until curl -s "http://localhost:$PORT/health" | grep -q '"status":"ok"'; do sleep 3; done
  for B in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge; do
    if command -v "$B" >/dev/null 2>&1; then
      "$B" --user-data-dir="$PROFILE" "http://localhost:$PORT" &
      exit 0
    fi
  done
  xdg-open "http://localhost:$PORT"
) &
WAITER=$!

sh ./"$LLAMAFILE" --server -m "$MODEL" --port $PORT -t 6 --ctx-size 2048 &
SERVER_PID=$!
echo $SERVER_PID > server.pid
wait $SERVER_PID
kill $WAITER 2>/dev/null
rm -f server.pid
