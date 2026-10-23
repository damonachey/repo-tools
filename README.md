# repo-tools

A collection of scripts for managing multiple git repositories and development directories.

## Scripts

### Bash Scripts (.sh)

#### `clean-build-dirs.sh`
Scans for and removes build output and dependency folders recursively from the current directory.

**Usage:**
```bash
./clean-build-dirs.sh            # list, then ask for YES
./clean-build-dirs.sh --whatif   # list only, delete nothing
./clean-build-dirs.sh -y         # delete without asking
```

**Features:**
- Always removes regenerated caches: `.venv`, `venv`, `node_modules`, `.vs`, `__pycache__`, `.pytest_cache`, `.mypy_cache`, `.ruff_cache`, `.tox`, `.nox`, `.hypothesis`, `.ipynb_checkpoints`, `htmlcov`, `coverage`, `TestResults`, `.next`, `.nuxt`, `.svelte-kit`, `.angular`, `.turbo`, `.parcel-cache`, `.vite`, `.astro`, `.gradle`, `.terraform`
- Removes `bin`, `obj`, `packages`, `artifacts`, `dist`, `build` and `out` only when a matching project file (`*.csproj`, `*.sln`, `package.json`, `CMakeLists.txt`, ...) sits alongside, so hand-made folders with those names are left alone
- Doesn't descend into `node_modules`, `.venv` or `venv`; the folder itself is removed
- Requires explicit "YES" confirmation unless `-y` is given

#### `open-changes.sh`
Scans all git repositories recursively and shows those with uncommitted changes or branches other than master.

**Usage:**
```bash
./open-changes.sh
```

**Features:**
- Identifies repositories with work in progress
- Shows git status in short format with branch information
- Helps locate repositories that need attention before cleanup

#### `each-repo.sh`
Executes a command in all git repositories found recursively from the current directory.

**Usage:**
```bash
./each-repo.sh <command>
./each-repo.sh git status
./each-repo.sh git pull
```

**Features:**
- Runs any specified command in each repository
- Useful for batch operations across multiple projects
- Shows which repositories are being processed

### Windows Batch Scripts (.cmd)

#### `CleanBuildDirs.cmd`
Windows equivalent of `clean-build-dirs.sh`. Removes build output and dependency folders recursively from the current directory.

**Usage:**
```cmd
CleanBuildDirs.cmd            REM list, then ask for YES
CleanBuildDirs.cmd /whatif    REM list only, delete nothing
CleanBuildDirs.cmd /y         REM delete without asking
```

**Features:**
- Same folder rules as the Bash version
- Falls back to robocopy when `rmdir` fails (e.g. paths that are too long)
- Pauses before closing when double-clicked from Explorer

#### `OpenChanges.cmd`
Windows equivalent of `open-changes.sh`. Finds repositories with uncommitted changes.

**Usage:**
```cmd
OpenChanges.cmd
```

**Features:**
- Scans for git repositories recursively
- Shows status of repositories with changes
- Windows-compatible version using batch commands

#### `EachRepo.cmd`
Windows equivalent of `each-repo.sh`. Executes commands in all git repositories.

**Usage:**
```cmd
EachRepo.cmd <command>
EachRepo.cmd git status
EachRepo.cmd git pull
```

**Features:**
- Batch operations across multiple repositories
- Windows-compatible implementation
- Flexible command execution

## Common Use Cases

1. **Workspace Cleanup**: Run `open-changes.sh` first to identify work in progress, then use `clean-build-dirs.sh` to remove build artifacts.

2. **Bulk Operations**: Use `each-repo.sh` to perform the same git operation across multiple repositories (e.g., `git fetch`, `git pull`, `git status`).

3. **Cross-Platform Development**: Use the appropriate script version (.sh for Unix/Linux, .cmd for Windows) based on your environment.

## Safety Notes

- Always check for uncommitted changes before running cleanup operations
- The clean scripts require explicit "YES" confirmation (unless `-y` / `/y` is given) and support a `--whatif` / `/whatif` dry run
- Scripts are designed to be safe and handle common edge cases
