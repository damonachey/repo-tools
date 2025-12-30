@echo off
setlocal enabledelayedexpansion

echo Scanning for uncommitted changes...

REM Enumerate folders
for /f "delims=" %%i in ('dir /s /b /ad .git') do (
    REM echo %%i
    pushd %%i\..\
    git status --short --branch | findstr /v master > NUL
    if !errorlevel! equ 0 (
        echo %%i
        git status --short --branch
    )
    popd
)

echo Done.
endlocal
