#!/usr/bin/bash

# Change to the data directory
cd ../data

# Select database to connect with
echo "------> Select your database number to CONNECT with: <------"
array=( $(ls -F | grep / | tr / " ") )
select choice in "${array[@]}"
do
    if [[ -z "$choice" ]]; then
        echo "There is no database! Try again."
        continue
    else
        cd "$choice"
        echo "You are connected to $choice database successfully."
        break
    fi
done

echo "Select an action:"

select action in "Create table" "List tables" "Drop table" "Insert in table" "Select from table" "Delete from table" "Update table"
do
    case $action in
        "Create table" )
            echo ".....Creating table..."
            source ../../software/create_table.sh
            ;;
        "List tables" )
            echo "....Listing tables..."
            source ../../software/list_tables.sh
            ;;
        "Drop table" )
            echo "....Dropping table..."
            source ../../software/drop_table.sh
            ;;
        "Insert in table" )
            echo "....Inserting in table..."
            source ../../software/insert_in_table.sh
            ;;
        "Select from table" )
            echo "....Selecting from table..."
            ../../software/select_from_table.sh
            ;;
        "Delete from table" )
            echo "....Deleting from table..."
            ../../software/delete_from_table.sh
            ;;
        "Update table" )
            echo "....Updating table..."
            ../../software/update_table.sh
            ;;

        * )
            echo "....Not a choice, try again."
            ;;
    esac
done
 