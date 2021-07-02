# Linux Automate MySQL Backupper Shell Script

First of all, this is an open source project and everyone is invited to improve it and develop it into something powerful.

This simple BASH script allows you to automate the backup of your MySQL database and send your backup to a secure remote location via FTP. Combined with cronjob you will also forget that you need to do a backup and it will do the hard and tedious work for you.

## How does this work?

When you download the script, you need to set certain parameters. Open the file in a text editor and set the parameters for the MySQL database, FTP connection (optional), backup location, file name and the number of days you want to save your backup on the current server.

```sh
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

# Filename (optional - by default database name)
FILE_NAME=${DATABASE_NAME}

# (optional) Place prefix in the file
FILE_NAME_PREFIX=''

# (optional) Place sufix in the file
FILE_NAME_SUFIX=''

## Number of days to keep local backup copy
BACKUP_RETAIN_DAYS=7

################## Update above values  ########################
################################################################
```

You must know that the `DATABASE_NAME` parameter can accept multiple databases separated by space (multi database backup in one file).

After entering the parameters, save the script, place it where you want (recommended in the `root` folder) and give the permission that it can be executed.

```sh
chmod +x mysql-backupper.sh
```

Now all you have to do is create a croncob for this script and you're ready to go. At the command prompt, type:

```sh
crontab –e
```

An editor will open where you need to enter the following setting in the last (new) line (as an example, and you will adjust as you need):

```sh
0 2 * * * /root/backup_database.sh
```

Save and your job is done.

## Things that need to be solve
- [ ] Delete backup files sent via FTP older than XX days
- [ ] Selection of compression type: ZIP, GZIP, TAR...
- [ ] Ability to send files via SSH

## Conclusion
The script is simple, setup is simple and takes the load off your back. This script will be improved and refined from time to time.

## Disclaimer
This script is open source, all parts of the code are clearly visible and there are no hidden scripts and options that can create a problem. The script is written as it is and the use of this script is entirely at your own risk. The author and other developers/contributors do not accept responsibility if this script creates some unexpected problems. You have decided to use it by yourself and all the responsibility is up to you.