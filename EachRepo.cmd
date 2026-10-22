@echo off

echo Scanning for git folders...
echo.

REM Enumerate standard repos (.git directory)
for /f "delims=" %%i in ('dir /s /b /ad .git') do (
    echo %%i
    pushd "%%i\..\"
    %*
    popd
)

REM Enumerate worktrees (.git file referencing main repo)
for /f "delims=" %%i in ('dir /s /b /a-d .git') do (
    echo %%i ^(worktree^)
    pushd "%%~dpi"
    %*
    popd
)

REM Enumerate bare repos (directories named *.git)
for /f "delims=" %%i in ('dir /s /b /ad *.git') do (
    if exist "%%i\HEAD" (
        echo %%i ^(bare^)
        pushd "%%i"
        %*
        popd
    )
)

echo.
echo Done.
