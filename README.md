# repo-tools

A collection of scripts for managing multiple git repositories and development directories.

## Scripts

### Bash Scripts (.sh)

#### `all-git-clean.sh`
Scans for and removes temporary development folders (bin, obj, .venv, venv, node_modules) recursively from the current directory.

**Usage:**
```bash
./all-git-clean.sh
```

**Features:**
- Shows folder sizes before deletion
- Requires explicit "YES" confirmation before proceeding
- Safe deletion with error handling

#### `all-git-open-changes.sh`
Scans all git repositories recursively and shows those with uncommitted changes or branches other than master.

**Usage:**
```bash
./all-git-open-changes.sh
```

**Features:**
- Identifies repositories with work in progress
- Shows git status in short format with branch information
- Helps locate repositories that need attention before cleanup

#### `all-git-run.sh`
Executes a command in all git repositories found recursively from the current directory.

**Usage:**
```bash
./all-git-run.sh <command>
./all-git-run.sh git status
./all-git-run.sh git pull origin main
```

**Features:**
- Runs any specified command in each repository
- Useful for batch operations across multiple projects
- Shows which repositories are being processed

### Windows Batch Scripts (.cmd)

#### `AllClean.cmd`
Windows equivalent of `all-git-clean.sh`. Removes temporary development folders recursively.

**Usage:**
```cmd
AllClean.cmd
```

**Features:**
- Same functionality as the Bash version
- Shows folder information before deletion
- Requires "YES" confirmation for safety

#### `AllGitOpenChanges.cmd`
Windows equivalent of `all-git-open-changes.sh`. Finds repositories with uncommitted changes.

**Usage:**
```cmd
AllGitOpenChanges.cmd
```

**Features:**
- Scans for git repositories recursively
- Shows status of repositories with changes
- Windows-compatible version using batch commands

#### `AllGitRun.cmd`
Windows equivalent of `all-git-run.sh`. Executes commands in all git repositories.

**Usage:**
```cmd
AllGitRun.cmd <command>
AllGitRun.cmd git status
AllGitRun.cmd git pull origin main
```

**Features:**
- Batch operations across multiple repositories
- Windows-compatible implementation
- Flexible command execution

## Common Use Cases

1. **Workspace Cleanup**: Run `all-git-open-changes.sh` first to identify work in progress, then use `all-git-clean.sh` to remove build artifacts.

2. **Bulk Operations**: Use `all-git-run.sh` to perform the same git operation across multiple repositories (e.g., `git fetch`, `git pull`, `git status`).

3. **Cross-Platform Development**: Use the appropriate script version (.sh for Unix/Linux, .cmd for Windows) based on your environment.

## Safety Notes

- Always check for uncommitted changes before running cleanup operations
- The clean scripts require explicit "YES" confirmation to prevent accidental deletion
- Scripts are designed to be safe and handle common edge cases
