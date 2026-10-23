#!/bin/bash

# clean-build-dirs.sh [-y] [--whatif]  - remove build/dep folders under the current dir
ROOT=$(pwd)
ASSUMEYES=
WHATIF=
for arg in "$@"; do
    case "$arg" in
        -y|/y) ASSUMEYES=1 ;;
        --whatif|/whatif) WHATIF=1 ;;
    esac
done

# ---- folders removed whenever found (regenerated caches / outputs, no source-name clash) ----
ALWAYS=(.venv venv node_modules .vs __pycache__ .pytest_cache .mypy_cache .ruff_cache .tox .nox .hypothesis .ipynb_checkpoints htmlcov coverage TestResults .next .nuxt .svelte-kit .angular .turbo .parcel-cache .vite .astro .gradle .terraform)

# ---- folders removed ONLY when a sibling project file is present (names often hand-authored) ----
#   scanned below via  scan <name> <marker globs...>

echo "Root:   $ROOT"
echo "Always: ${ALWAYS[*]}"
echo "Guarded (need a project file alongside): bin obj dist build out packages artifacts"
echo ""
echo "Scanning..."

LIST=()

# $1 = folder name, remaining args = marker globs (none = unconditional)
scan() {
    local name=$1; shift
    local dir marker f
    # never descend into node_modules/.venv/venv; the container itself gets removed, its contents are noise
    while IFS= read -r -d '' dir; do
        if [ $# -eq 0 ]; then
            LIST+=("$dir")
            continue
        fi
        for marker in "$@"; do
            for f in "$(dirname "$dir")"/$marker; do
                if [ -e "$f" ]; then
                    LIST+=("$dir")
                    continue 3
                fi
            done
        done
    done < <(find "$ROOT" -type d \( -name node_modules -o -name .venv -o -name venv \) -prune -name "$name" -print0 \
                       -o -type d -name "$name" -print0)
}

for name in "${ALWAYS[@]}"; do scan "$name"; done
scan bin       "*.csproj" "*.vbproj" "*.fsproj" "*.sln"
scan obj       "*.csproj" "*.vbproj" "*.fsproj" "*.sln"
scan packages  "*.sln"
scan artifacts "*.sln" "Directory.Build.props"
scan dist      "package.json"
scan build     "package.json" "CMakeLists.txt"
scan out       "package.json"

COUNT=${#LIST[@]}
if [ "$COUNT" -eq 0 ]; then
    echo "Nothing to clean."
    exit 0
fi

for dir in "${LIST[@]}"; do echo "  $dir"; done

echo ""
echo "$COUNT folders found."
if [ -n "$WHATIF" ]; then
    echo ""
    echo "--whatif - nothing deleted."
    exit 0
fi

if [ -z "$ASSUMEYES" ]; then
    echo ""
    read -r -p "Type YES to delete these folders: " confirm
    if [ "${confirm^^}" != "YES" ]; then
        echo "Aborting."
        exit 0
    fi
fi

echo ""
echo "Deleting..."
FAIL=0
for dir in "${LIST[@]}"; do
    if [ -d "$dir" ]; then
        echo "  $dir"
        rm -rf "$dir" 2>/dev/null
        if [ -d "$dir" ]; then
            echo "    !! FAILED"
            FAIL=$((FAIL + 1))
        fi
    fi
done

echo ""
if [ "$FAIL" -eq 0 ]; then
    echo "Done. Removed $COUNT folders."
else
    echo "Done. $FAIL of $COUNT failed."
fi
