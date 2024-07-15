#!/usr/bin/bash
cd ../data

while true
do 
    echo "write your DB name"
    read db_name   
            
            # validating the name
    case $db_name in

        # empty name
        '' )
            echo "the name can't be empty "
            continue ;;

        # have spaces 
        *[[:space:]]* )
            echo "the name can't have spaces"
            continue ;;

        # numbers
        [0-9]* )
            echo "the name can't start with numbers"
            continue ;;

        # the valid name
        *[a-zA-Z_]*[a-zA-Z_] | [a-zA-Z_] )
            if [ -d "$db_name" ]; 
            then           
                echo "the DATABASE already exists"
                continue
            else
                mkdir "$db_name"
                echo "Your database created successfully."
                break 
            fi         
            ;;
        # invalid input
        * )
            echo "invalid name"
            continue;;
    esac
done

cd - > /dev/null

echo "1) CREATE_DB      2) LIST_DB    3) CONNECT_DB    4) DROP_DB"
