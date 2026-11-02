@echo off
setlocal
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0FlowNote.ps1"
if errorlevel 1 (
    echo.
    echo FlowNote could not start. Check that Windows PowerShell 5.1 is installed.
    pause
)
