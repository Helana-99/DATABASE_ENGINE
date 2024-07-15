#!/usr/bin/bash

cd ../data

echo "------>select your database number to DROP :<------"
array=( `ls -F | grep / | tr / " " `)
select choice in "${array[@]}"
do
    if [[ -z "$choice" ]]
    then
        echo "There is no database! Try again."
        continue
    else
        # Check if the directory is empty
        if [ -z "$(ls -A "$choice")" ]
        then
            rmdir "$choice"
            echo "Your empty database $choice deleted successfully"
        else
            read -p "The database $choice is not empty. Do you want to delete it and all its contents? (y/n) " confirm
            if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
            then
                rm -r "$choice"
                echo "Your database $choice and all its contents were deleted successfully"
            else
                echo "Deletion of $choice canceled"
            fi
        fi
        break
    fi
done
cd - > /dev/null
