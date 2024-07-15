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
    echo "------> Select an operation: <------"
    echo "1. Select all rows"
    echo "2. Select by column"
    echo "3. Projection"
    echo "4. Back to main menu"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Selected all rows from $table_name:"
            display_table "$table_name"
            ;;
        2)
            read -p "Enter the column name to select: " column_name
            # Check if column exists
            column_index=$(head -1 "$table_name" | tr ',' '\n' | grep -n -w "$column_name" | cut -d: -f1)
            if [ -z "$column_index" ]; then
                echo "Column $column_name does not exist!"
            else
                echo "Selected column $column_name from $table_name:"
                awk -F',' -v col="$column_index" '
                {
                    if (NR == 1) {
                        print "------------------------------------------------------"
                        printf "| %-12s |\n", $col
                        print "------------------------------------------------------"
                    } else {
                        printf "| %-12s |\n", $col
                    }
                }
                END {
                    print "------------------------------------------------------"
                }
                ' "$table_name"
            fi
            ;;
        3)
            echo "Enter columns separated by commas (e.g., 1,3,5):"
            read columns
            # Validate columns input
            if [[ "$columns" =~ ^[0-9,]+$ ]]; then
                echo "Selected columns $columns from $table_name:"
                awk -F',' -v cols="$columns" '
                BEGIN {
                    split(cols, col_arr, ",")
                }
                {
                    if (NR == 1) {
                        print "------------------------------------------------------"
                        for (i in col_arr) {
                            printf "| %-12s", $col_arr[i]
                        }
                        print "|"
                        print "------------------------------------------------------"
                    } else {
                        for (i in col_arr) {
                            printf "| %-12s", $col_arr[i]
                        }
                        print "|"
                    }
                }
                END {
                    print "------------------------------------------------------"
                }
                ' "$table_name"
            else
                echo "Invalid input! Please enter column numbers separated by commas."
            fi
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
