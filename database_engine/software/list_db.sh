#!/usr/bin/bash

echo "------------------YOUR DATABASES------------------"

 cd ../data
 ls -F |grep / | tr / " " # tr to replace / with space at the end of data base name
 

cd - > /dev/null
echo "1) CREATE_DB      2) LIST_DB    3) CONNECT_DB    4) DROP_DB"
 