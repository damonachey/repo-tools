@echo off

echo Scanning for temporary dev folders...

REM Enumerate folders
for /f "delims=" %%i in ('dir /s /b /ad bin obj .venv venv node_modules') do (
    echo %%i
    dir /s %%i | tail -2 | head -1
)

echo.
set /p confirm=Type YES to delete all these folders: 
if not "%confirm%"=="YES" (
    echo Aborting.
    goto :eof
)

echo Deleting folders...
for /f "delims=" %%i in ('dir /s /b /ad bin obj .venv venv node_modules') do (
    if exist "%%i" (
        echo Deleting %%i
        rmdir /s "%%i"
    )
)

echo Done.
pause
