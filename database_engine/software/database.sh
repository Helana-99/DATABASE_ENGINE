#!/usr/bin/bash

select choice in CREATE_DB LIST_DB CONNECT_DB DROP_DB
do 
case $choice in
CREATE_DB )
echo "....creating data base...."
source ./create_db.sh
;;
LIST_DB )
echo "....listing data base...."
source ./list_db.sh
;;
CONNECT_DB )
echo "....connecting data base...."
source ./connect_db.sh


;;
DROP_DB )
echo "....drop data base...."
source ./drop_db.sh
;;
esac
done