#!/bin/bash

echo "Scanning for uncommitted changes..."
echo ""

# Enumerate standard repos (.git directory)
find . -name ".git" -type d | while read gitdir; do
    repodir=$(dirname "$gitdir")
    pushd "$repodir" > /dev/null
    
    # Check if there are any changes (not on master branch or uncommitted changes)
    if git status --porcelain --branch | grep -q -v "master"; then
        echo "$gitdir"
        git status --short --branch
    fi
    
    popd > /dev/null
done

# Enumerate worktrees (.git file referencing main repo)
find . -name ".git" -type f | while read gitfile; do
    repodir=$(dirname "$gitfile")
    mainrepo=$(cd "$repodir" && git rev-parse --show-toplevel 2>/dev/null) || continue
    
    pushd "$repodir" > /dev/null
    
    if git status --porcelain --branch | grep -q -v "master"; then
        echo "$gitfile (worktree of $mainrepo)"
        git status --short --branch
    fi
    
    popd > /dev/null
done

echo ""
echo "Done."
