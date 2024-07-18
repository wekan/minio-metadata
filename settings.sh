#!/bin/bash

# 1) MongoDB settings

export MONGOURI='mongodb://localhost:27017/wekan'
export MONGOHOST=localhost
export MONGOPORT=27017
export MONGODBNAME=wekan

# 2) SQLite settings

export SQLITEDBNAME=wekan.db

# 3) Minio settings
#
# 3.1) At Minio web interface https://127.0.0.1:9000
# 3.2) Add new ACCESSKEY and SECRETKEY
# 3.3) Add new bucket with name wekan
# 3.4) Add wekan alias with mc minio CLI:
# mc config host add wekan http://127.0.0.1:9000 ACCESSKEY SECRETKEY
# - below setting means, that files will be stored in
#   minio alias, minio bucket, in subdirectories attachments and avatars

export MINIOBUCKETNAME=wekan/wekan

# 4) Minio testing:
# mc ls wekan/wekan


