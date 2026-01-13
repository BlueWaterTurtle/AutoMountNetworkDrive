@echo offf
SET ThisScriptDirectory=%dp0
SET PowerShellScriptPath=%ThisScriptDirectory%mapNetDrive.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File "%PowerShellScriptPath%"
REM change the path as needed.