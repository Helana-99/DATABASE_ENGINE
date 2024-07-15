#!/usr/bin/bash

# List tables
tables=( $(ls -1) )

# Check if there are any tables
if [ ${#tables[@]} -eq 0 ]; then
    echo "You don't have any tables. Please create a table first."
    exit 0
fi

echo "Your tables:"
ls -1

# Select table
while true; do
    read -p "Enter the table name to insert data into: " table_name
    if [ -f "$table_name" ]; then
        break
    else
        echo "The table $table_name does not exist. Please enter a valid table name."
    fi
done

# Read column names from the table
IFS=',' read -r -a column_names < "$table_name"

# Insert rows into the table dynamically
while true; do
    echo "Insert data for a new row:"

    row_data=()
    for ((c = 0; c < ${#column_names[@]}; c++)); do
        while true; do
            read -p "Enter data for ${column_names[c]}: " value

            # Ensure the first column ("id") is a positive integer
            if [[ $c -eq 0 ]]; then
                if [[ "$value" =~ ^[1-9][0-9]*$ ]]; then
                    row_data+=("$value")
                    break
                else
                    echo "Error: The first column (id) must be a positive number."
                fi
            else
                # Allow letters or numbers, ensure the value is not empty
                if [[ -n "$value" ]]; then
                    row_data+=("$value")
                    break
                else
                    echo "Error: Please enter a valid value for ${column_names[c]}."
                fi
            fi
        done
    done

    # Prepare row data for writing to table
    row_data_str=$(IFS=,; echo "${row_data[*]}")
    echo "$row_data_str" >> "$table_name"

    # Ask user if they want to add another row
    read -p "Do you want to add another row? (y/n): " add_more
    if [[ "$add_more" != "y" ]]; then
        break
    fi
done

echo "Data has been added to the $table_name table."




