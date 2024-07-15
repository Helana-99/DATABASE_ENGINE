#!/usr/bin/bash

# Function to list available tables
list_tables() {
    echo "Your tables:"
    ls -1
}

# Function to check if a table exists
check_table_exists() {
    if [ ! -f "$1" ]; then
        echo "Table $1 does not exist!"
        return 1
    fi
    return 0
}

# Function to display table data
display_table() {
    awk -F',' '
    {
        if (NR == 1) {
            header = $0
        } else {
            data[NR-1] = $0
        }
    }
    END {
        split(header, headers, ",")
        for (i in headers) {
            printf "| %-12s", headers[i]
        }
        print "|"
        print "------------------------------------------------------"
        for (i in data) {
            split(data[i], row, ",")
            for (j in row) {
                printf "| %-12s", row[j]
            }
            print "|"
        }
        print "------------------------------------------------------"
    }
    ' "$1"
}

echo "------> Select your database name: <------"
array=( $(ls -F | grep / | tr / " ") )
select db_choice in "${array[@]}"
do
    if [[ -z "$db_choice" ]]; then
        echo "No databases found! Please create a database directory."
        exit 1
    else
        cd "$db_choice"
        echo "You are working in the $db_choice database."
        break
    fi
done

# List available tables in the selected database
list_tables

# Select table
while true; do
    read -p "Enter the table name to work with: " table_name
    if check_table_exists "$table_name"; then
        break
    else
        echo "The table $table_name does not exist. Please enter a valid table name."
    fi
done

# Menu for operations on the selected table
while true; do
    # Display the table before showing the menu
    echo "Current table data:"
    display_table "$table_name"
    
    echo "------> Select an operation: <------"
    echo "1. Insert new row"
    echo "2. Update specific cell"
    echo "3. Update entire row"
    echo "4. Back to main menu"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Inserting new row into $table_name."
            read -p "Enter new row data separated by commas (e.g., value1,value2,value3): " new_row
            echo "$new_row" >> "$table_name"
            echo "Updated table data:"
            display_table "$table_name"
            ;;
        2)
            read -p "Enter the row number to update (starting from 1 for the first data row): " row_number
            read -p "Enter the column name to update: " column_name
            read -p "Enter the new value: " new_value

            column_index=$(head -1 "$table_name" | tr ',' '\n' | grep -n -w "$column_name" | cut -d: -f1)
            if [ -z "$column_index" ]; then
                echo "Column $column_name does not exist!"
            else
                awk -v row="$row_number" -v col="$column_index" -v new_val="$new_value" -F',' 'BEGIN{OFS=","}
                {
                    if (NR == row+1) {
                        $col = new_val
                    }
                    print
                }
                ' "$table_name" > "$table_name.tmp" && mv "$table_name.tmp" "$table_name"

                echo "Updated table data:"
                display_table "$table_name"
            fi
            ;;
        3)
            read -p "Enter the row number to update (starting from 1 for the first data row): " row_number
            read -p "Enter new row data separated by commas (e.g., value1,value2,value3): " new_row_data
            
            awk -v row="$row_number" -v new_row="$new_row_data" -F',' 'BEGIN{OFS=","}
            {
                if (NR == row+1) {
                    $0 = new_row
                }
                print
            }
            ' "$table_name" > "$table_name.tmp" && mv "$table_name.tmp" "$table_name"

            echo "Updated table data:"
            display_table "$table_name"
            ;;
        4)
            cd - > /dev/null
            echo "Returning to the main menu."
            break
            ;;
        *)
            echo "Invalid option! Please enter a valid option."
            ;;
    esac
done
