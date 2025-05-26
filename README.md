# Transfer files from MongoDB GridFS to Minio file server, and MongoDB text to SQLite

## MinIO Community version 2.0 is going back to be an object browser only

- https://github.com/minio/object-browser/blob/master/CHANGELOG.md
- https://news.ycombinator.com/item?id=44093987
- https://www.reddit.com/r/selfhosted/comments/1kva3pw/avoid_minio_developers_introduce_trojan_horse/
  - " I dont know what everyone is so upset about. Their commercial licensed version appears to start at only $96,000/year! https://min.io/pricing "
- Alternatives:
  - SeaweedFS: https://github.com/seaweedfs/seaweedfs (Apache 2.0)
  - Zenko: https://github.com/scality/Zenko (Apache 2.0)

## Introduction

- TLDR:
  - Bash scripts to transfer attachment and avatar files from MongoDB GridFS to Minio file server, using below CLI commands.
- Why:
  - To make MongoDB Server database size smaller (like from 800 GB to 10 GB), store files elsewhere, and have files visible in upcoming version of WeKan.
  - It is very slow to backup 800 GB database, using mongodump to backup could take many days.
  - This separate file transfer tool is required, because using WeKan built-in migrations still has too many time consuming step.
  - Meteor WeKan will continue using MongoDB for text data. Files can be stored outside of MongoDB.
  - Upcoming Multiverse WeKan https://github.com/wekan/wekan/issues/4578 will use SQLite database for text data. Files are stored outside of SQLite.
- WeKan ® is Open Source kanban
  - MIT license
  - Website https://wekan.github.io
  - Repo https://github.com/wekan/wekan
  - WeKan is made with Javascript: Meteor, Node.js 14.x, MongoDB 5.x
  - WeKan attachments and avatars are stored in MongoDB GridFS format in MongoDB database.
- MongoDB is noSQL database
  - SSPL license https://en.wikipedia.org/wiki/Server_Side_Public_License
  - Website https://www.mongodb.com
  - Repo https://github.com/mongodb/mongo
  - Download MongoDB Community Server https://www.mongodb.com/try/download/community
  - Database queries are made with Javascript (not with SQL)
  - MongoDB server is made with C++
  - MongoDB drivers for programming languages are at https://www.mongodb.com/docs/drivers/
- MongoDB Shell is CLI to connect to MongoDB server and have interactive shell, making database queries
  - Apache 2.0 License
  - Download https://www.mongodb.com/try/download/shell
  - Repo https://github.com/mongodb/mongo-tools
  - Made with Go
- MongoDB Tools
  - https://www.mongodb.com/try/download/tools
  - mongofiles is MongoDB CLI to save files from MongoDB Server GridFS to local files
    - Apache 2.0 license
    - Repo https://github.com/mongodb/mongo-tools
  - mongodump can save from MongoDB server to files at dump directory, binary format, used for backup
  - mongorestore can restore dump directory binary files back to MongoDB server
- Meteor is fullstack web framework
  - MIT license
  - Website https://www.meteor.com
  - Repo https://github.com/meteor/meteor
  - Meteor 2.x uses Node.js 14.x and MongoDB 5.x
  - Upcoming Meteor 3.0 will support Node.js 18.x and MongoDB 6.x
  - Meteor is made with Javascript
- MinIO server is like AWS S3, but self-hosted one executeable binary
  - AGPLv3 license
  - Website https://min.io
  - https://github.com/minio/minio
  - Has web interface for example at http://127.0.0.1:9000
  - Has API like AWS S3
  - MinIO is made with Go
- mc is MinIO CLI is command line one executeable binary
  - AGPLv3 license
  - Website https://min.io/docs/minio/linux/reference/minio-mc.html
  - Repo  https://github.com/minio/mc
  - can copy files to minio server, etc
  - mc is made with Go
- SQLite is SQL database in one executeable binary that stores all tables etc in one .sqlite file
  - Public Domain license
  - Website https://www.sqlite.org
  - Repo at bottom of page https://sqlite.org/download.html
  - SQLite is made with C89

Related, not used here:

- DBGate is GUI to connect to MongoDB database server to view and edit database JSON content
  - MIT license
  - Website https://dbgate.org
  - Repo https://github.com/dbgate/dbgate
- RClone is CLI similar to mc, but supports more file services
  - MIT license
  - Website https://rclone.org
  - https://github.com/rclone/rclone
  - RClone is made with Go

## Requirements

Installed commands:

- mc: minio mc command https://min.io/docs/minio/linux/reference/minio-mc.html
- mongofiles and mongoexport: newest from MongoDB tools https://www.mongodb.com/try/download/database-tools
- sqlite3: For example, `sudo apt install sqlite3`
- Bash shell, like Linux or WSL.

## Transferring files

1. Edit `settings.sh` to change MongoDB, SQLite and Minio settings.

2. a) Do everything of 2b) at one step

 `./start.sh`

2. b) Do in separate steps

`./mongoexport.sh` (Copy text from MongoDB to SQLite)

`./transfer.sh` (Copy files from MongoDB to Minio)

Logging transfer to textfile:

`./transfer.sh > logfile.txt`

Looking at transfer progress at other terminal:

`tail -f logfile.txt`

mc command has command line option to add metadata

Metadata can be added be selected from SQLite database in transfer.sh script.

Metadata needs to need in JSON format properly.

mc command also has SQL to search.

How to remove extra text when looking logfile, not needed working results:
```
cat logfile.txt | grep -v success | less
```
- That -v option removes that kind of text from logfile, only showing errors or other remaining text.
- In remaining log text can be seen, is there any file transfer errors, or does some file need to be transferred again.
- To be tested, does exporting newer attachments require different OID1 etc format.

## What will happen while tranferring files

1. Export MongoDB text to wekan.db (Temporary .csv files at directory csv will be deleted after they have been imported to SQLite)

2. Export file from MongoDB GridFS to current directory

3. Upload file to Minio

4. Delete file from current directory, to not fill more disk space.

5. Go back to step 2. for each file

NOTE: Running scripts again currently will overwrite wekan.db file new data and transfer files to minio again.


## TODO

- Current bugs:
  - When transferring files, some of files are not transferred. Is this bug in mc command, bash script, or MinIO server?
  - When metadata is added, some metadata is missing for some files.
  - Does MinIO not work on ext4 on Linux? https://github.com/minio/minio/issues/16602#issuecomment-1427509203
  - This MinIO bug is problem, someone recommended to not use MinIO because of it https://github.com/minio/minio/issues/9419
  - Would MinIO server AGPLv3 license change WeKan MIT licence to AGPLv3 ? Some recommend staying away from MinIO: https://news.ycombinator.com/item?id=35328316
  - What alternatives there are for MinIO ?
  - Attachment filename sanitize when storing files serverside, like use only ObjectID or hash https://github.com/wekan/wekan/issues/4416
- Add more metadata to minio.
  - Create SQL query for FILEID
  - For each FILEID, do queries for metadata, like cardname, username, etc
  - Combine metadata to correct JSON file format that is OK to save to minio
