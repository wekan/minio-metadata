# Transfer files from MongoDB GridFS to Minio file server

## Introduction

- WeKan ® is Open Source kanban
  - MIT license
  - Website https://wekan.github.io
  - Repo https://github.com/wekan/wekan
  - WeKan is made with Javascript: Meteor, Node.js 14.x, MongoDB 5.x
  - WeKan attachments and avatars are stored in MongoDB GridFS format in MongoDB database.
- MongoDB is noSQL database
  - SSPL license (some previous version was AGPLv3)
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
- mc is MinIO CLI is command line one execute
  - AGPLv3 license
  - Website https://min.io/docs/minio/linux/reference/minio-mc.html
  - Repo  https://github.com/minio/mc
  - can copy files to minio server, etc
  - mc is made with Go
- RClone is CLI similar to mc, but supports more file services
  - MIT license
  - Website https://rclone.org
  - https://github.com/rclone/rclone
  - RClone is not used in scripts below
  - RClone is made with Go
- SQLite is SQL database that stores all tables etc in one .sqlite file
  - Public Domain lisence
  - Website https://www.sqlite.org
- Transfer files scripts be

## Requirements

Installed commands:

- mc: minio mc command https://min.io/docs/minio/linux/reference/minio-mc.html
- mongofiles and mongoexport: newest from MongoDB tools https://www.mongodb.com/try/download/database-tools
- sqlite3: For example, `sudo apt install sqlite3`

## Transferring files

1. Edit settings.sh

2. `./start.sh`

## What will happen while tranferring files

This will:

1. Export MongoDB text to wekan.sqlite (Temporary .csv files at directory csv/ )

2. Export file from MongoDB GridFS to current directory

3. Upload file to Minio

4. Delete file from current directory, to not fill more disk space.

5. Go back to step 2. for each file

## TODO

- Add metadata to minio. All that metadata is also at wekan.sqlite, so it could be also added later.
