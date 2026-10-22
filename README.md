# repo-tools

A collection of scripts for managing multiple git repositories and development directories.

## Scripts

### Bash Scripts (.sh)

#### `clean-build-dirs.sh`
Scans for and removes temporary development folders (bin, obj, .venv, venv, node_modules) recursively from the current directory.

**Usage:**
```bash
./clean-build-dirs.sh
```

**Features:**
- Shows folder sizes before deletion
- Requires explicit "YES" confirmation before proceeding
- Safe deletion with error handling

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
./each-repo.sh git pull origin main
```

**Features:**
- Runs any specified command in each repository
- Useful for batch operations across multiple projects
- Shows which repositories are being processed

### Windows Batch Scripts (.cmd)

#### `CleanBuildDirs.cmd`
Windows equivalent of `clean-build-dirs.sh`. Removes temporary development folders recursively.

**Usage:**
```cmd
CleanBuildDirs.cmd
```

**Features:**
- Same functionality as the Bash version
- Shows folder information before deletion
- Requires "YES" confirmation for safety

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
EachRepo.cmd git pull origin main
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
- The clean scripts require explicit "YES" confirmation to prevent accidental deletion
- Scripts are designed to be safe and handle common edge cases
