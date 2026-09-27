# Full Setup Instructions

## What you need

- A computer running macOS, Windows, or Linux
- At least 8 GB of RAM; 16 GB or more is recommended for smoother performance with 7 to 8B parameter models
- 5 to 40 GB of free storage depending on the model you choose
- A USB thumb drive (optional, only needed for the portable setup), formatted ExFAT so it works on both Mac and Windows
- Comfort using Terminal or Command Prompt for a handful of commands
- No GPU required. Llamafile runs on CPU, though a GPU will speed things up if you have one

## Step 1: Download llamafile

Llamafile is a single-file program that bundles a model runner and a web chat interface. It runs the same way on macOS, Windows, and Linux.

1. Go to the [llamafile releases page](https://github.com/mozilla-ai/llamafile/releases) on GitHub
2. Download the latest release for your platform (a single executable file)
3. On Mac or Linux, make it executable: `chmod +x llamafile-<version>`
4. On Windows, you may need to rename the file to add `.exe` for it to run

After downloading, run `./llamafile-<version> --help` to see the flags available in that exact version. Flag names change across releases. For example, `--no-mmap` is deprecated in newer builds in favor of `--load-mode mmap`, so don't assume flags from this guide or an older version still apply without checking.

## Step 2: Download a model

Llamafile runs models in the GGUF format, downloaded separately, commonly from [Hugging Face](https://huggingface.co).

Look for a `.gguf` file with a quantization label like `Q4_K_M` in the name. Lower numbers (Q2, Q3) are smaller and faster but less accurate; higher numbers (Q6, Q8) are larger and closer to full quality but slower. Q4_K_M is a common middle ground.

Model size in parameters (3B, 7B, 8B, 13B, and so on) is the biggest factor in speed on CPU-only hardware, more than the quantization level. See "Choosing a model size" below before downloading.

Place the downloaded `.gguf` file in the same top-level folder as the llamafile program and this repo's `scripts/` folder.

## Step 3: Set up the folder

Put everything together in one folder:

```
your-drive-or-folder/
  llamafile-<version>
  <model-name>.gguf
  scripts/
    mac/...
    windows/...
    linux/...
```

For a portable setup, use this same layout at the top level of a thumb drive, for example `/Volumes/<drive-name>/` on Mac or a drive letter on Windows.

## Step 4: Run it manually (first time, to confirm it works)

From inside the folder:

```
cd your-drive-or-folder
./llamafile-<version> --server -m <model-name>.gguf --port 8081
```

`--server` opens the browser-based chat page. Without it, you get a plain terminal chat instead. `-m` points at the model file. `--port` sets which local port the chat page uses; pick one not already in use (8080 is a common default and often taken).

Open `http://localhost:8081` in your browser once running. The page loads immediately, but the model can take seconds to several minutes to finish loading, longer from a USB drive. Nothing responds until loading finishes.

To stop it manually: close the browser tab, then press Ctrl+C in the terminal.

## Step 5: Use the launcher scripts

This repo's `scripts/` folder has ready-to-use start and stop scripts for each OS. They:

- Start the server and wait for it to be ready before opening a browser
- Point the browser at a `browser-profile` folder in the same directory, so settings and chat history save there instead of your computer's normal browser storage
- Save the server's process ID so the stop script can shut it down cleanly

Run the one matching your OS (see Quick Start in the main README). Each needs a small permission step before it will run:

**Mac**: `chmod +x` the `.command` files, then clear Gatekeeper's quarantine flag:
```
xattr -d com.apple.quarantine scripts/mac/start.command scripts/mac/stop.command
```
If macOS still blocks it, right-click the file and choose Open instead of double-clicking, or approve it under System Settings > Privacy & Security.

**Windows**: downloaded `.bat` files are sometimes blocked. Right-click the file, choose Properties, and check Unblock at the bottom if present. If double-clicking does nothing, run it from Command Prompt instead so you can see any error.

**Linux**: `chmod +x scripts/linux/start.sh scripts/linux/stop.sh`. Some desktop environments also need "Allow executing file as program" checked under the file's Properties > Permissions tab.

## Step 6: Make settings portable across computers

The `browser-profile` folder the scripts create is what carries your settings and chat history. For it to actually follow you to a different computer:

- **Use the same port every time.** Browser storage is keyed by address and port together; changing ports looks like visiting a different site.
- **Use the same browser every time.** The profile folder format is specific to one browser (Chrome or Edge), so use whichever one you'll have installed everywhere.

Test before relying on it: change a setting, close the browser, reopen, confirm it stuck. Then eject and reinsert the drive and confirm again. Then try a second computer.

## Choosing a model size for your hardware

Model size is the single biggest factor in CPU-only response speed, more than quantization level or RAM headroom.

| Model size | What to expect |
| --- | --- |
| 3B | Fast, usable replies on almost any modern laptop. Good default for everyday CPU-only use |
| 7 to 8B | Noticeably slower on CPU, still usable, especially with 16 GB or more RAM |
| 13B and above | Slow on CPU-only hardware, generally not practical without a GPU |

If replies feel too slow at 8B, dropping to a 3B model is usually a bigger win than tweaking thread count or context size flags.

## Troubleshooting

**"Stream resume produced no new bytes, giving up"**: The browser chat page timed out waiting for a slow reply, not the model failing. The terminal is often still generating in the background. Fix by speeding up generation (run from an internal drive instead of USB, use a smaller model).

**"tensor ... data is not within the file bounds, model is corrupted or incomplete"**: The model file is damaged or the copy didn't finish. Check file size against the original:
```
ls -la <path-to-file>
```
If sizes don't match, delete the incomplete copy and recopy it fully. For extra certainty, compare checksums with `shasum` (Mac/Linux) or `certutil -hashfile` (Windows) on both copies.

**Chat page opens but no model loaded**: Confirm `-m` points at the exact model filename in that folder.

**Port already in use**: Pick a different `--port` number.

**"xattr: No such xattr: com.apple.quarantine"**: Harmless. On Mac this just means the file wasn't quarantined in the first place.

**Deprecated flag warnings**: Harmless, the command still runs. Check `--help` for the current flag name.

## Sources

- [llamafile quickstart](https://docs.mozilla-ai.dev/llamafile/getting-started/quickstart)
- [llamafile on GitHub](https://github.com/mozilla-ai/llamafile)
