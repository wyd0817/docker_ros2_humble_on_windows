@echo off
REM Quickly open project directory in VSCode

REM Set your project path
set "PROJECT_PATH=D:\docker_ros2_humble_on_windows"

REM Check if path exists
if not exist "%PROJECT_PATH%" (
    echo Error: Directory does not exist %PROJECT_PATH%
    timeout /t 3 /nobreak >nul
    exit /b 1
)

REM Open directory in VSCode
code "%PROJECT_PATH%"

REM Auto close window
exit