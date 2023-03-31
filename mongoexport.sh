#!/bin/bash

source settings.sh

rm wekan.sqlite csv/*.csv

mongoexport --uri="${MONGOURI}" --collection=attachments --type=csv --fieldFile=fields/attachments-fields.txt --out=csv/attachments.csv
mongoexport --uri="${MONGOURI}" --collection=attachments.files --type=csv --fieldFile=fields/attachments.files-fields.txt --out=csv/attachments.files.csv
mongoexport --uri="${MONGOURI}" --collection=avatars --type=csv --fieldFile=fields/avatars-fields.txt --out=csv/avatars.csv
mongoexport --uri="${MONGOURI}" --collection=avatars.files --type=csv --fieldFile=fields/avatars.files-fields.txt --out=csv/avatars.files.csv
mongoexport --uri="${MONGOURI}" --collection=cfs.attachments.filerecord --type=csv --fieldFile=fields/cfs.attachments.filerecord-fields.txt --out=csv/cfs.attachments.filerecord.csv
mongoexport --uri="${MONGOURI}" --collection=cfs.avatars.filerecord --type=csv --fieldFile=fields/cfs.avatars.filerecord-fields.txt --out=csv/cfs.avatars.filerecord.csv
mongoexport --uri="${MONGOURI}" --collection=cfs_gridfs.attachments.files --type=csv --fieldFile=fields/cfs_gridfs.attachments.files-fields.txt --out=csv/cfs_gridfs.attachments.files.csv
mongoexport --uri="${MONGOURI}" --collection=cfs_gridfs.avatars.files --type=csv --fieldFile=fields/cfs_gridfs.avatars.files-fields.txt --out=csv/cfs_gridfs.avatars.files.csv

echo ".mode csv
.import csv/attachments.csv attachments
.import csv/attachments.files.csv attachments.files
.import csv/avatars.csv avatars
.import csv/avatars.files.csv avatars.files
.import csv/cfs.attachments.filerecord.csv cfs.attachments.filerecord
.import csv/cfs.avatars.filerecord.csv cfs.avatars.filerecord
.import csv/cfs_gridfs.attachments.files.csv cfs_gridfs.attachments.files
.import csv/cfs_gridfs.avatars.files.csv cfs_gridfs.avatars.files
.quit" | sqlite3 wekan.sqlite

rm csv/*.csv
