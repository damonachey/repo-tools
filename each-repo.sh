#!/bin/bash

echo "Scanning for git folders..."
echo ""

# Enumerate standard repos (.git directory)
find . -name ".git" -type d | while read gitdir; do
    repodir=$(dirname "$gitdir")
    echo "$gitdir"
    pushd "$repodir" > /dev/null
    "$@"
    popd > /dev/null
done

# Enumerate worktrees (.git file referencing main repo)
find . -name ".git" -type f | while read gitfile; do
    repodir=$(dirname "$gitfile")
    echo "$gitfile (worktree)"
    pushd "$repodir" > /dev/null
    "$@"
    popd > /dev/null
done

# Enumerate bare repos (directories named *.git)
find . -name "*.git" -type d -not -name ".git" | while read gitdir; do
    [ -f "$gitdir/HEAD" ] || continue
    echo "$gitdir (bare)"
    pushd "$gitdir" > /dev/null
    "$@"
    popd > /dev/null
done

echo ""
echo "Done."