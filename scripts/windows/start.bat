@echo off
cd /d "%~dp0..\.."
set LLAMAFILE=llamafile-0.10.6.exe
set MODEL=dolphin-2.9.4-llama3.1-8b-Q4_K_M.gguf
set PORT=8081
set PROFILE=%cd%\browser-profile

if not exist "%PROFILE%" mkdir "%PROFILE%"

set "BROWSER="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"

echo Loading the model. This can take a few minutes.
echo To stop later, run scripts\windows\stop.bat from the repo root.

start "" /min powershell -NoProfile -Command "while($true){try{$r=Invoke-WebRequest -UseBasicParsing http://localhost:%PORT%/health; if($r.StatusCode -eq 200){break}}catch{}; Start-Sleep 3}; if($env:BROWSER){Start-Process $env:BROWSER -ArgumentList '--user-data-dir=%PROFILE%','http://localhost:%PORT%'}else{Start-Process http://localhost:%PORT%}"

"%LLAMAFILE%" --server -m "%MODEL%" --port %PORT% -t 6 --ctx-size 2048
