#!/bin/bash
cd "$(dirname "$0")/../.." || exit 1
LLAMAFILE="llamafile-0.10.6"
MODEL="dolphin-2.9.4-llama3.1-8b-Q4_K_M.gguf"
PORT=8081
PROFILE="$PWD/browser-profile"

xattr -d com.apple.quarantine "$LLAMAFILE" 2>/dev/null
chmod +x "$LLAMAFILE" 2>/dev/null
mkdir -p "$PROFILE"

echo "Starting server on port $PORT from $PWD"
echo "Loading the model. This can take a few minutes."
echo "To stop later, run scripts/mac/stop.command from the repo root."

(
  until curl -s "http://localhost:$PORT/health" | grep -q '"status":"ok"'; do
    sleep 3
  done
  if [ -d "/Applications/Google Chrome.app" ]; then
    open -na "Google Chrome" --args --user-data-dir="$PROFILE" "http://localhost:$PORT"
  elif [ -d "/Applications/Microsoft Edge.app" ]; then
    open -na "Microsoft Edge" --args --user-data-dir="$PROFILE" "http://localhost:$PORT"
  else
    open "http://localhost:$PORT"
  fi
) &
WAITER=$!

./"$LLAMAFILE" --server -m "$MODEL" --port $PORT -t 6 --ctx-size 2048 &
SERVER_PID=$!
echo $SERVER_PID > server.pid

wait $SERVER_PID
kill $WAITER 2>/dev/null
rm -f server.pid
