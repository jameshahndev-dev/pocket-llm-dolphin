@echo off
set PORT=8081
echo Close the browser window first, then press any key to stop the server.
pause >nul
for /f "tokens=5" %%p in ('netstat -ano ^| findstr :%PORT% ^| findstr LISTENING') do (
  taskkill /PID %%p /F
)
echo Stopped.
pause
