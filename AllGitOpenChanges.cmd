@echo off
setlocal enabledelayedexpansion

echo Scanning for uncommitted changes...
echo.

REM Enumerate standard repos (.git directory)
for /f "delims=" %%i in ('dir /s /b /ad .git') do (
    pushd "%%i\..\"
    git status --short --branch | findstr /v master > NUL
    if !errorlevel! equ 0 (
        echo %%i
        git status --short --branch
    )
    popd
)

REM Enumerate worktrees (.git file referencing main repo)
for /f "delims=" %%i in ('dir /s /b /a-d .git') do (
    set "mainrepo="
    for /f "delims=" %%j in ('git -C "%%~dpi" rev-parse --show-toplevel 2^>NUL') do (
        set "mainrepo=%%j"
    )
    if defined mainrepo (
        pushd "%%~dpi"
        git status --short --branch | findstr /v master > NUL
        if !errorlevel! equ 0 (
            echo %%i ^(worktree of !mainrepo!^)
            git status --short --branch
        )
        popd
    )
)

echo.
echo Done.
endlocal
