#!/bin/bash

echo "Scanning for temporary dev folders..."
echo ""

# Enumerate folders
find . -type d \( -name "bin" -o -name "obj" -o -name ".venv" -o -name "venv" -o -name "node_modules" \) | while read -r dir; do
    echo "$dir"
    du -sh "$dir" 2>/dev/null || echo "Unable to determine size"
done

echo
read -p "Type YES to delete all these folders: " confirm
if [ "$confirm" != "YES" ]; then
    echo "Aborting."
    exit 0
fi

echo "Deleting folders..."
find . -type d \( -name "bin" -o -name "obj" -o -name ".venv" -o -name "venv" -o -name "node_modules" \) | while read -r dir; do
    if [ -d "$dir" ]; then
        echo "Deleting $dir"
        rm -rf "$dir"
    fi
done

echo ""
echo "Done."
read -p "Press Enter to continue..."