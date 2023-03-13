#!/bin/bash

# IN PROGRESS. NOT READY YET. WILL BE READY SOON.

source settings.sh

# Adding metadata to file with mc command:
# mc --attr key1=value1\;key2=value2\;key3=value3
# https://min.io/docs/minio/linux/reference/minio-mc/mc-cp.html#syntax

function transfer {
  MAXFILECOUNT=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT count(*) FROM '${FILECOLLFILES}';" | tr -d "'")
  #MAXFILECOUNT=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT count(*) FROM '${FILECOLLFILES}';" | tr -d "'")
  MAXFILECOUNT=1
  for ((FILENUMBER=1; FILENUMBER<=MAXFILECOUNT; FILENUMBER++))
  do
    OBJECTID=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT substr(_id, 10, 24) FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    FILENAME=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT filename FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    CONTENTTYPE=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT contentType FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    UPLOADDATE=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT uploadDate FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    MD5=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT md5 FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    # OLD OBJECTID:
    OID1="'{\"\$oid\":\""
    OID2="\"}'"
    # NEW OBJECTID:
    #OID1="'ObjectId(\""
    #OID2="\")'"
    FINALOBJECTID=$OID1$OBJECTID$OID2
    FINALFILENAME=$OBJECTID-$FILENAME
    #echo $FINALOBJECTID
    echo "File number: ${FILENUMBER} / ${MAXFILECOUNT}"
    echo "mc --attr objectid=$OBJECTID"
    #SAVEFILE=$(echo mongofiles --host ${MONGOHOST} --port ${MONGOPORT} -d ${MONGODBNAME} --prefix ${FILECOLL} get_id ${FINALOBJECTID} --local ${FINALFILENAME})
    #echo $FINALFILENAME
    #eval $SAVEFILE
    #echo $SAVEFILE
    #FILEMETA=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT filename FROM \"cfs_gridfs.attachments.files\" WHERE _id=\"ObjectId($OBJECTID)\";")
    #echo $FILEMETA
    #UPLOADMINIO=$(echo mc cp "${FINALFILENAME}" "${MINIOBUCKETNAME}/${FILEDIR}/${FINALFILENAME}")
    #eval $UPLOADMINIO
    #echo $UPLOADMINIO
    #echo rm "${FINALFILENAME}"
  done
}

#function listfiles() {
#  mongofiles --host ${MONGOHOST} --port ${MONGOPORT} -d ${MONGODBNAME} --prefix=$FILECOLL list
#}

# 1) Transfer attachments
FILEDIR=attachments
FILECOLL=cfs_gridfs.attachments
FILECOLLFILES=cfs_gridfs.attachments.files
transfer
#FILECOLL=attachments
#FILECOLLFILES=attachments.files
#transfer

# 2) Transfer avatars
#FILEDIR=avatars
#FILECOLL=cfs_gridfs.avatars
#FILECOLLFILES=cfs_gridfs.avatars.files
#transfer
#FILECOLL=avatars
#FILECOLLFILES=avatars.files
#transfer
