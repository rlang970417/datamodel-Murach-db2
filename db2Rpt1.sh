#!/bin/bash
#

# Global VARs
export PATH=/usr/bin:/bin:/home/db2inst1/sqllib/bin:/home/db2inst1/sqllib/adm:/home/db2inst1/sqllib/gskit/bin

# Function runs the sql script passed as the 1st argurmnet
function RunSql()
{
    printf "Running %s\n" "$1"
    
    db2 attach to db2inst1
    # Remove the old RPT1 database
    db2 force applications all
    db2 disconnect ALL
    db2 drop schema om restrict
    db2 drop schema ex restrict
    db2 drop schema ap restrict
    db2 drop database RPT1
    # Create the new RPT1 database
    db2 create database RPT1
    db2 connect to RPT1
    db2 create schema ap authorization db2inst1
    db2 create schema ex authorization db2inst1
    db2 create schema om authorization db2inst1
    # Create tables and add data to our tables
    db2 -tf db2-create_ap_tables.sql -z ap_db.log
    db2 -tf db2-create_ex_tables.sql -z ex_db.log
    db2 -tf db2-create_om_tables.sql -z om_db.log
}

# 
if [ ! -e db2-create_ap_tables.sql ]; then
    echo "Cannot Build Database. Missing File : db2-create_ap_tables.sql"
    exit 1
fi

if [ ! -e db2-create_ex_tables.sql ]; then
    echo "Cannot Build Database. Missing File : db2-create_ex_tables.sql"
    exit 1
fi

if [ ! -e db2-create_om_tables.sql ]; then
    echo "Cannot Build Database. Missing File : db2-create_om_tables.sql"
    exit 1
fi

RunSql
