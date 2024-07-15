
#!/usr/bin/bash

# List tables
echo "Your tables:"
ls -1

# Create table
while true; do
    # Read the input
    read -p "Enter your table name to create: " table_name

    # Validating the table name
    case $table_name in
        '' )
            echo "The name cannot be empty."
            continue;;
        *[[:space:]]* )
            echo "The name of the table cannot have any spaces."
            continue;;
        [0-9]* )
            echo "The name cannot start with digits."
            continue;;
        [a-zA-Z_]* )
            if [ -f "$table_name" ]; then           
                echo "The table already exists."
                continue
            else
                touch "$table_name"
                echo "You have created your $table_name table successfully."
                break
            fi
            ;;
        * )
            echo "Invalid name. Please use only letters, numbers, and underscores."
            continue;;
    esac
done

# Ask for the number of columns
while true; do
    read -p "Enter the number of columns: " columns
    if [[ "$columns" =~ ^[1-9][0-9]*$ ]]; then
        break
    else
        echo "Please enter a valid positive number."
    fi
done

# Automatically set the first column as primary key
echo "The first column  is set as the primary key"

# Read column names and ensure primary key is an integer
declare -a column_names
for ((c = 1; c <= columns; c++)); do
    while true; do
        read -p "Enter name for column $c: " col_name

        # Check if the column name is empty
        if [[ -z "$col_name" ]]; then
            echo "The name can't be empty."
            continue
        fi
        
        # Check if the column name contains spaces
        if [[ "$col_name" =~ [[:space:]] ]]; then
            echo "The name can't contain spaces."
            continue
        fi
        
        # Check if the column name starts with a number
        if [[ "$col_name" =~ ^[0-9] ]]; then
            echo "The name can't start with a number."
            continue
        fi
        
        # Check if the column name contains only valid characters
        if [[ ! "$col_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo "The name must start with a letter and contain only letters, numbers, and underscores."
            continue
        fi
        
        # Check if the column name already exists
        if printf '%s\n' "${column_names[@]}" | grep -q -w "$col_name"; then
            echo "Oops, it looks like $col_name column name already exists."
            continue
        fi

        # Add the column name to the array
        column_names+=("$col_name")
        break
    done
done

# Write column names to the table file
column_names_str=$(IFS=,; echo "${column_names[*]}")
echo "$column_names_str" > "$table_name"


# Write column names to the table file
column_names_str=$(IFS=,; echo "${column_names[*]}")
echo "$column_names_str" > "$table_name"

echo "Columns created for table $table_name successfully. :)"
     
