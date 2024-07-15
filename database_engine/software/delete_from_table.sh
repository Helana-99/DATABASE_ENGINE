
#!/usr/bin/bash


echo "------> Select your table name to Delete from: <------"
array=( $(ls -F | grep / | tr / " ") )
select choice in "${array[@]}"
do
    if [[ -z "$choice" ]]; then
        echo "There is no database! Try again."
        continue
    else
        cd "$choice"
        echo "You are deleting from $choice database successfully."
        break
    fi
done

# Function to list available tables
echo "Your tables:"
ls -1

# Function to check if a database exists
check_db_exists() {
    db_path="../data/$1"
    if [ ! -d "$db_path" ]; then
        echo "Database $1 does not exist!"
        return 1
    fi
    return 0
}

# Select table
while true; do
    read -p "Enter the table name to delete data from: " table_name
    if [ -f "$table_name" ]; then
        break
    else
        echo "The table $table_name does not exist. Please enter a valid table name."
    fi
done


while true;
 do
    echo "------>Select an option:<------"
    echo "1. Delete by column"
    echo "2. Delete by row"
    echo "3. Delete all rows"
    echo "4. Back"
    read -p "Enter your choice: " choice

    case $choice in
        1)
        read -p "Enter the column name to delete: " column_name
        column_index=$(head -1 "$table_name" | tr ',' '\n' | grep -n -w "$column_name" | cut -d: -f1)
        if [ -z "$column_index" ]; then
            echo "Column $column_name does not exist!"
        else
            cut -d, -f$column_index --complement "$table_name" > temp && mv temp "$table_name"
            echo "Column $column_name deleted successfully!"
        fi
        ;;
        2)
            read -p "Enter the primary key or unique identifier of the row to delete: " primary_key
            row_index=$(grep -n -w "$primary_key" "$table_name" | cut -d: -f1)
            if [ -z "$row_index" ]; then
                echo "Row with primary key $primary_key does not exist!"
            else
                sed -i "${row_index}d" "$table_name"
                echo "Row with primary key $primary_key deleted successfully!"
            fi
            ;;
        3)
            # Preserve the header and delete all rows
            head -1 "$table_name" > temp && mv temp "$table_name"
            echo "All rows deleted successfully, but the table structure is preserved!"
            ;;
        4)
            cd - > /dev/null
            break
            ;;
    esac
done
