#!/bin/bash

##########################################
##                                      ##
##   Automate MySQL Backupper           ##
##   ------------------------           ##
##   Written By: Ivijan-Stefan Stipic   ##
##   URL: https://infinitumform.com     ##
##   E-mail: infinitumform@gmail.com    ##
##   Last Update: Jul 02, 2021          ##
##   Version: 1.0.0                     ##
##                                      ##
##########################################

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`



################################################################
################## Update below values  ########################

## Database
DATABASE_NAME=''
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER=''
MYSQL_PASSWORD=''

# FTP (optional)
FTP_HOST=''
FTP_USER=''
FTP_PASSWORD=''
FTP_PATH='/'

# Backup location
DB_BACKUP_PATH='~/backups'

# Filename setup
FILE_NAME=${DATABASE_NAME} 	## (optional)	We can change this to some other name
FILE_NAME_PREFIX=''		## (optional)	Place prefix in the file 
FILE_NAME_SUFIX='' 		## (optional)	Place sufix in the file

BACKUP_RETAIN_DAYS=7   ## Number of days to keep local backup copy

################## Update above values  ########################
################################################################



##### Remove backups older than {BACKUP_RETAIN_DAYS} days  #####
DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`
if [ ! -z ${DB_BACKUP_PATH} ]; then
	cd ${DB_BACKUP_PATH}
	if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
		rm -rf ${DBDELDATE}
		echo  "Old backups cleaned up"
	fi
fi

# Let's create a new file name
BACKUP_FILE=${FILE_NAME_PREFIX}${FILE_NAME}${FILE_NAME_SUFIX}-${TODAY}.sql.gz	## Filename
BACKUP_FILE=`echo "${BACKUP_FILE}"|sed 's/ /-/g'`				## Replace spaces
BACKUP_FILE_PATH=${DB_BACKUP_PATH}/${TODAY}					## File path
FULL_BACKUP_FILE_PATH=${BACKUP_FILE_PATH}/${BACKUP_FILE}			## Full file location

#### Create MySQL dump and save to gZIP ####
if [ ! -z ${DATABASE_NAME} ]; then

	mkdir -p ${DB_BACKUP_PATH}/${TODAY}
	echo "Backup started for database - ${DATABASE_NAME}"

	mysqldump --host=${MYSQL_HOST} --port=${MYSQL_PORT} --databases ${DATABASE_NAME} --add-drop-database --triggers --routines --events --password=${MYSQL_PASSWORD} --user=${MYSQL_USER} --single-transaction | gzip -9 > ${FULL_BACKUP_FILE_PATH}

	if [ $? -eq 0 ]; then
		echo "Database backup successfully completed"
		echo "Backup location: ${FULL_BACKUP_FILE_PATH}"
	else
		echo "Error found during backup"
	fi

else
	echo "ERROR: Datbase not defined"
fi

#### Send backup via FTP ####
if [ ! -z ${FTP_USER} ]; then
	echo "Sending bakup file ${BACKUP_FILE} to ${FTP_HOST} via FTP"

cd ${BACKUP_FILE_PATH}
ftp -in <<END_SCRIPT
open ${FTP_HOST}
user ${FTP_USER} ${FTP_PASSWORD}
binary
passive
cd ${FTP_PATH}
put ${BACKUP_FILE}
close
bye
END_SCRIPT
	
	if [ $? -eq 0 ]; then
		echo "File ${BACKUP_FILE} successfuly sent via FTP to remote bakup server"
	else
		echo "FTP error. File was not sent properly."
	fi
fi
### End of script ####
