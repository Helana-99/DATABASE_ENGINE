#!/usr/bin/bash

# List all tables (files) in the current directory
tables=( $(ls) )  # List all files in the current directory

# Check if the directory is empty
if [ ${#tables[@]} -eq 0 ]; 
    then
    echo "The database is empty."
    exit 0
fi

echo "------> Select a table to DROP: <------"

select table_choice in "${tables[@]}"
do
    if [[ -z "$table_choice" ]]; 
        then
        echo "Invalid choice. Please try again."
        continue
    fi
    
    # Drop the selected table
    rm "$table_choice"
    echo "Your table $table_choice has been deleted successfully."
    
    break
done