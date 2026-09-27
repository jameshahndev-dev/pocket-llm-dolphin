# Dolphin LLM Thumb Drive

Run an offline, privacy-friendly LLM chat from a USB thumb drive (or your computer's internal drive), on Mac, Windows, or Linux, with one-click launchers and settings that travel with the drive.

No internet connection required once set up. Nothing leaves your machine.

## What this is

This repo holds the launcher scripts and setup instructions for running [llamafile](https://github.com/Mozilla-Ocho/llamafile) with a Dolphin-based Llama 3.1 8B model, entirely offline, with a browser-based chat page.

It does **not** include the model file or the llamafile program itself. Those are large binaries (several GB) and are downloaded separately. See [docs/INSTRUCTIONS.md](docs/INSTRUCTIONS.md) for exact links and steps.

## Quick start

1. Download `llamafile` (see [docs/INSTRUCTIONS.md](docs/INSTRUCTIONS.md) for the link) and a GGUF model file, such as a Dolphin Llama 3.1 8B quantized version.
2. Clone or download this repo to the top level of your thumb drive, or to a folder on your computer.
3. Place the downloaded llamafile program and `.gguf` model file in that same top-level folder, alongside the `scripts/` folder from this repo.
4. Run the start script for your OS:
   - Mac: `scripts/mac/start.command`
   - Windows: `scripts\windows\start.bat`
   - Linux: `scripts/linux/start.sh`
5. Wait for your browser to open automatically, and start chatting.
6. When done, run the matching stop script, and close the browser window first.

Full setup, including exact download links, model choice guidance, and troubleshooting, is in [docs/INSTRUCTIONS.md](docs/INSTRUCTIONS.md).

## Folder layout once set up

```
your-drive-or-folder/
  llamafile-<version>              <- downloaded separately, not in this repo
  <model-name>.gguf                <- downloaded separately, not in this repo
  browser-profile/                 <- created automatically on first run
  scripts/
    mac/start.command
    mac/stop.command
    windows/start.bat
    windows/stop.bat
    linux/start.sh
    linux/stop.sh
```

## Requirements

- macOS, Windows, or Linux
- 8 GB RAM minimum, 16 GB or more recommended
- 5 to 40 GB free storage depending on model size
- No GPU required

## License

MIT. See [LICENSE](LICENSE).
