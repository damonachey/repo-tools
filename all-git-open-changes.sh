#!/bin/bash

echo "Scanning for uncommitted changes..."
echo ""

# Enumerate folders containing .git
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

echo ""
echo "Done."
