@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM AllClean.cmd [/y] [/whatif]  - remove build/dep folders under this script's dir
set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"
set "ASSUMEYES=" & set "WHATIF="
for %%A in (%*) do (
    if /i "%%~A"=="/y"      set "ASSUMEYES=1"
    if /i "%%~A"=="/whatif" set "WHATIF=1"
)

REM ---- folders removed whenever found (regenerated caches / outputs, no source-name clash) ----
set "ALWAYS=.venv venv node_modules .vs __pycache__ .pytest_cache .mypy_cache .ruff_cache .tox .nox .hypothesis .ipynb_checkpoints htmlcov coverage TestResults .next .nuxt .svelte-kit .angular .turbo .parcel-cache .vite .astro .gradle .terraform"

REM ---- never descend into these; the container itself gets removed, its contents are noise ----
set "PRUNE=/c:\node_modules\ /c:\.venv\ /c:\venv\"

REM ---- folders removed ONLY when a sibling project file is present (names often hand-authored) ----
REM   scanned below via  call :scan "<name>" "<space-separated marker globs>"

echo Root:   %ROOT%
echo Always: %ALWAYS%
echo Guarded (need a project file alongside): bin obj dist build out packages artifacts
echo.
echo Scanning...

set "LIST=%TEMP%\allclean_%RANDOM%%RANDOM%.txt"
break > "%LIST%"
set /a COUNT=0

for %%T in (%ALWAYS%) do call :scan "%%T" ""
call :scan "bin"       "*.csproj *.vbproj *.fsproj *.sln"
call :scan "obj"       "*.csproj *.vbproj *.fsproj *.sln"
call :scan "packages"  "*.sln"
call :scan "artifacts" "*.sln Directory.Build.props"
call :scan "dist"      "package.json"
call :scan "build"     "package.json CMakeLists.txt"
call :scan "out"       "package.json"
goto :afterScan

:scan
REM %1 = folder name, %2 = marker globs ("" = unconditional)
for /f "delims=" %%i in ('dir /s /b /ad "%ROOT%\%~1" 2^>nul') do (
    echo(%%i | findstr /i %PRUNE% >nul || (
        if "%~2"=="" (
            call :add "%%i"
        ) else (
            call :hasMarker "%%~dpi" "%~2" && call :add "%%i"
        )
    )
)
exit /b

:hasMarker
REM %1 = parent dir (trailing backslash), %2 = space-separated glob list
REM exit /b 0 if any marker file exists in the parent dir, else exit /b 1
set "_p=%~1"
set "_m=%~2"
:hasMarker_loop
for /f "tokens=1* delims= " %%m in ("%_m%") do (
    if exist "%_p%%%m" exit /b 0
    set "_m=%%n"
)
if defined _m goto :hasMarker_loop
exit /b 1

:add
>>"%LIST%" echo(%~1
set /a COUNT+=1
exit /b

:afterScan
if %COUNT%==0 ( echo Nothing to clean. & goto :done )

for /f "usebackq delims=" %%a in ("%LIST%") do echo   %%a

echo.
echo %COUNT% folders found.
if defined WHATIF ( echo. & echo /whatif - nothing deleted. & goto :done )

if not defined ASSUMEYES (
    echo.
    set /p "confirm=Type YES to delete these folders: "
    if /i not "!confirm!"=="YES" ( echo Aborting. & goto :done )
)

echo.
echo Deleting...
set "EMPTY=%TEMP%\allclean_empty_%RANDOM%" & md "%EMPTY%" 2>nul
set /a FAIL=0
for /f "usebackq delims=" %%a in ("%LIST%") do (
    if exist "%%a\" (
        echo   %%a
        rmdir /s /q "%%a" 2>nul
        if exist "%%a\" (
            robocopy "%EMPTY%" "%%a" /purge /njh /njs /ndl /nc /ns /nfl >nul 2>nul
            rmdir /s /q "%%a" 2>nul
        )
        if exist "%%a\" ( echo     ^!^! FAILED & set /a FAIL+=1 )
    )
)
rmdir /s /q "%EMPTY%" 2>nul

echo.
if %FAIL%==0 (
    echo Done. Removed %COUNT% folders.
) else (
    echo Done. %FAIL% of %COUNT% failed.
)

:done
del "%LIST%" 2>nul
echo %cmdcmdline% | find /i "%~nx0" >nul && pause
endlocal
