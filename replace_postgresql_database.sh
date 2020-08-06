#!/bin/bash

################
# Replace the database
###Get the input from user
if [ "$(whoami)" != "postgres" ]; then
        echo "ERROR : Run script as postgres (postgres !!) please"
        exit 1
fi
echo "Enter the copy database name: "
read copyDatabase
currentDateTime=`date +"%Y-%m-%dT%T"`
copyDatabaseFile="$copyDatabase-$currentDateTime.sql"
echo "Database will be copied to " $copyDatabaseFile

echo "Enter the database name to delete"
read databaseToDelete;

echo "Enter the new database name"
read databaseToCreate;
## Copy the database to file
pg_dump $copyDatabase > $copyDatabaseFile
echo "Database is dumped to " $copyDatabaseFile
## Delete the database
dropdb $databaseToDelete;
echo $databaseToDelete " is deleted"
## Create new dabase
createdb $databaseToCreate;
echo $databaseToCreate " is created"
## Restore it to #$databaseToCreate
psql -U postgres $databaseToCreate < $copyDatabaseFile
##
echo "Restore successfull@" `date +"%Y-%m-%dT%T"`
