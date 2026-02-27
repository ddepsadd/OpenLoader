
@echo off
cd /d "%~dp0"

call publish_linux.bat
call publish_osx.bat
call publish_windows.bat
