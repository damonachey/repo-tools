#!/bin/bash

echo "Scanning for git folders..."

# Enumerate folders containing .git
find . -name ".git" -type d | while read gitdir; do
    repodir=$(dirname "$gitdir")
    echo "$gitdir"
    pushd "$repodir" > /dev/null
    "$@"
    popd > /dev/null
done

echo "Done."