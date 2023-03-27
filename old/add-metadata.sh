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
    UPAT=$(echo "SELECT \"original.updatedAt\" FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    UPDATEDAT=$(sqlite3 -quote ${SQLITEDBNAME} "${UPAT}" | tr -d "'")
    SIZE=$(echo "SELECT \"original.size\" FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    FILESIZE=$(sqlite3 -quote ${SQLITEDBNAME} "${SIZE}" | tr -d "'")
    CO=$(echo "SELECT copies FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    COPIES=$(sqlite3 -quote ${SQLITEDBNAME} "${CO}" | tr -d "'")
    BO=$(echo "SELECT boardId FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    BOARDID=$(sqlite3 -quote ${SQLITEDBNAME} "${BO}" | tr -d "'")
    CA=$(echo "SELECT cardId FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    CARDID=$(sqlite3 -quote ${SQLITEDBNAME} "${CA}" | tr -d "'")
    US=$(echo "SELECT userId FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    USERID=$(sqlite3 -quote ${SQLITEDBNAME} "${US}" | tr -d "'")
    UPL=$(echo "SELECT \"original.updatedAt\" FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    UPLOADEDAT=$(sqlite3 -quote ${SQLITEDBNAME} "${UPL}" | tr -d "'")
    BTITLE=$(echo "SELECT title FROM boards WHERE _id=\"${BOARDID}\";" | tr -d "'")
    echo $BTITLE
    BOARDTITLE=$(sqlite3 -quote ${SQLITEDBNAME} "${BTITLE}" | tr -d "'")
    echo $BOARDTITLE
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
    echo "mc --attr \"objectId=$OBJECTID\;filename=$FILENAME\;filesize=$FILESIZE;contentType=$CONTENTTYPE\;md5=$MD5\;uploadDate=$UPLOADDATE\;updatedAt=$UPDATEDAT\;uploadedAt=$UPLOADEDAT\;copies=$COPIES\;boardId=$BOARDID\;boardTitle=$BOARDTITLE\;userId=$USERID\""
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
FILERECORD=cfs.attachments.filerecord
transfer
#FILECOLL=attachments
#FILECOLLFILES=attachments.files
#FILERECORD=attachments.filerecord
#transfer

# 2) Transfer avatars
#FILEDIR=avatars
#FILECOLL=cfs_gridfs.avatars
#FILECOLLFILES=cfs_gridfs.avatars.files
#FILERECORD=cfs.avatars.filerecord
#transfer
#FILECOLL=avatars
#FILECOLLFILES=avatars.files
#FILERECORD=avatarts.filerecord
#transfer
