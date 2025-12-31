@echo off

echo Scanning for git folders...

REM Enumerate folders
for /f "delims=" %%i in ('dir /s /b /ad .git') do (
    echo %%i
    pushd %%i\..\
    %*
    popd
)

echo.
echo Done.
