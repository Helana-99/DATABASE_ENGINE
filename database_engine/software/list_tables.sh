#!/usr/bin/bash

# Check if there are any tables (files) in the current directory
tables=( $(ls -1) )

# If no tables, notify the user and exit
if [ ${#tables[@]} -eq 0 ]; then
    echo "No tables found in the selected database."
    exit 0
fi

echo "Tables in $choice database:"

# List all tables in the current directory
for table in "${tables[@]}"; do
    echo "  Table: $(basename "$table")"
done
