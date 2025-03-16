#!/bin/bash

source settings.sh

urldecode() { local u="${1//+/ }"; printf '%b' "${u//%/\\x}"; }

#urldecode $1


function transfer {
  MAXFILECOUNT=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT count(*) FROM '${FILECOLLFILES}';" | tr -d "'")
  #MAXFILECOUNT=4
  for ((FILENUMBER=1; FILENUMBER<=MAXFILECOUNT; FILENUMBER++))
  do
    OBJECTID=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT substr(_id, 10, 24) FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    FILENAME=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT filename FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    # OLD OBJECTID:
    OID1="'{\"\$oid\":\""
    OID2="\"}'"
    # NEW OBJECTID:
    #OID1="'ObjectId(\""
    #OID2="\")'"
    FINALOBJECTID=$OID1$OBJECTID$OID2
    #echo $FINALOBJECTID
    echo "File number: ${FILENUMBER} / ${MAXFILECOUNT}"
    # Save from MongoDB to filename OBJECTID.
    SAVEFILE=$(echo mongofiles --host ${MONGOHOST} --port ${MONGOPORT} -d ${MONGODBNAME} --prefix ${FILECOLL} get_id ${FINALOBJECTID} --local ${OBJECTID})
    eval $SAVEFILE
    FILETYPE=$(file $OBJECTID)
    FILEEXTENSION=$(file --extension $OBJECTID)
    FILEEXTENSIONLENGTH=$(echo ${#FILEEXTENSION})
    #cat yourfile.txt | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]'
    #TEMPFILENAME=$(echo urldecode $FILENAME | iconv -f utf-8 -t us-ascii//TRANSLIT | tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]')
    ##TEMPFILENAME=$(urldecode $FILENAME | sed -e 's/[()%]//g')
    TEMPFILENAME=$(urldecode $FILENAME)
    #sed 's|"||g' - | sed 's| |_|g' - | sed 's|(||g' - | sed 's|)||g' - |
    # If there is no file extension, add it
    if [ "${TEMPFILENAME##*.}" = "" ]; then
       $TEMPFILENAME=$(echo "$TEMPFILENAME.$FILEEXTENSION")
    fi
    # Adding metadata to file with mc command:
    # mc --attr key1=value1\;key2=value2\;key3=value3
    # https://min.io/docs/minio/linux/reference/minio-mc/mc-cp.html#syntax
    CONTENTTYPE=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT contentType FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    UPLOADDATE=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT uploadDate FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    #UPLOADEDATTEXT=$(echo "SELECT \"original.updatedAt\" FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    UPLOADEDAT=$(sqlite3 -quote ${SQLITEDBNAME} "${UPLOADEDATTEXT}" | tr -d "'")
    #UPDATEDATTEXT=$(echo "SELECT \"original.updatedAt\" FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    UPDATEDAT=$(sqlite3 -quote ${SQLITEDBNAME} "${UPDATEDATTEXT}" | tr -d "'")
    #FILESIZETEXT=$(echo "SELECT \"original.size\" FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    FILESIZE=$(sqlite3 -quote ${SQLITEDBNAME} "${FILESIZETEXT}" | tr -d "'")
    #COPIESTEXT=$(echo "SELECT copies FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    COPIES=$(sqlite3 -quote ${SQLITEDBNAME} "${COPIESTEXT}" | tr -d "'")
    #BOARDIDTEXT=$(echo "SELECT boardId FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\";" | tr -d "'")
    BOARDID=$(sqlite3 -quote ${SQLITEDBNAME} "${BOARDIDTEXT}" | tr -d "'")
    BOARDTITLETEXT=$(echo "SELECT title FROM boards WHERE _id=\"${BOARDID}\" LIMIT 1;" | tr -d "'")
    BOARDTITLE=$(sqlite3 -quote ${SQLITEDBNAME} "${BOARDTITLETEXT}" | tr -d "'")
    #CARDIDTEXT=$(echo "SELECT cardId FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\" LIMIT 1;" | tr -d "'")
    CARDID=$(sqlite3 -quote ${SQLITEDBNAME} "${CARDIDTEXT}" | tr -d "'")
    CARDTITLETEXT=$(echo "SELECT title FROM cards WHERE _id=\"${CARDID}\" LIMIT 1;" | tr -d "'")
    CARDTITLE=$(sqlite3 -quote ${SQLITEDBNAME} "${CARDTITLETEXT}" | tr -d "'")
    LISTIDTEXT=$(echo "SELECT listId FROM cards WHERE _id=\"${CARDID}\" LIMIT 1;" | tr -d "'")
    LISTID=$(sqlite3 -quote ${SQLITEDBNAME} "${LISTIDTEXT}" | tr -d "'")
    LISTTITLETEXT=$(echo "SELECT title FROM lists WHERE _id=\"${LISTID}\" LIMIT 1;" | tr -d "'")
    LISTTITLE=$(sqlite3 -quote ${SQLITEDBNAME} "${LISTTITLETEXT}" | tr -d "'")
    SWINLANEIDTEXT=$(echo "SELECT swimlaneId FROM cards WHERE _id=\"${CARDID}\" LIMIT 1;" | tr -d "'")
    SWIMLANEID=$(sqlite3 -quote ${SQLITEDBNAME} "${SWIMLANEIDTEXT}" | tr -d "'")
    SWIMLANETITLETEXT=$(echo "SELECT title FROM swimlanes WHERE _id=\"${SWIMLANEID}\" LIMIT 1;" | tr -d "'")
    SWIMLANETITLE=$(sqlite3 -quote ${SQLITEDBNAME} "${SWIMLANETITLETEXT}" | tr -d "'")
    #USERIDTEXT=$(echo "SELECT userId FROM \"${FILERECORD}\" WHERE copies LIKE \"%${OBJECTID}%\" LIMIT 1;" | tr -d "'")
    USERID=$(sqlite3 -quote ${SQLITEDBNAME} "${USERIDTEXT}" | tr -d "'")
    USERNAMETEXT=$(echo "SELECT username FROM users WHERE _id=\"${USERID}\" LIMIT 1;" | tr -d "'")
    USERNAME=$(sqlite3 -quote ${SQLITEDBNAME} "${USERNAMETEXT}" | tr -d "'")
    FULLNAMETEXT=$(echo "SELECT \"profile.fullname\" FROM users WHERE _id=\"${USERID}\" LIMIT 1;" | tr -d "'")
    FULLNAME=$(sqlite3 -quote ${SQLITEDBNAME} "${FULLNAMETEXT}" | tr -d "'")
    EMAILSTEXT=$(echo "SELECT emails FROM users WHERE _id=\"${USERID}\" LIMIT 1;" | tr -d "'")
    EMAILS=$(sqlite3 -quote ${SQLITEDBNAME} "${EMAILSTEXT}" | tr -d "'" | sed 's|"||g' -)
    #| tr -d "'" | sed 's|"||g' - | sed 's|[{address:||g' - | sed 's|,verified:false}]||g' - | sed 's|,verified:true}]||g' -)
    #| sed 's/[{"address":"//g' - | sed 's/","verified":false}]"/,/g' - | sed 's/","verified":true}]"/,/g' -| sed 's/""/,/g' -)
    MD5=$(sqlite3 -quote ${SQLITEDBNAME} "SELECT md5 FROM '${FILECOLLFILES}' WHERE ROWID=${FILENUMBER};" | tr -d "'")
    SHA256SUM=$(sha256sum $OBJECTID | tr -d "'" | awk '{ print $1 }')
    SHA512SUM=$(sha512sum $OBJECTID | tr -d "'" | awk '{ print $1 }')
    # OLD OBJECTID:
    OID1="'{\"\$oid\":\""
    OID2="\"}'"
    FINALFILENAME=$(echo $OBJECTID-$TEMPFILENAME)
    echo $FINALFILENAME
    if [ ! -d files2 ]; then
      mkdir files2
    fi
    mv "$OBJECTID" "files2/$FINALFILENAME"
    # NEW OBJECTID:
    #OID1="'ObjectId(\""
    #OID2="\")'"
    A1="Content-Type=${CONTENTTYPE};X-Amz-Meta-Objectid=${OBJECTID};X-Amz-Meta-Filename=${FILENAME};X-Amz-Meta-Filesize=${FILESIZE};"
    A2="X-Amz-Meta-Md5=${MD5};X-Amz-Meta-Sha256=${SHA256SUM};X-Amz-Meta-Sha512=${SHA512SUM};"
    A3="X-Amz-Meta-Uploaddate=${UPLOADDATE};X-Amz-Meta-Updatedat=${UPDATEDAT};X-Amz-Meta-Uploadedat=${UPLOADEDAT};"
    A4="X-Amz-Meta-Boardid=${BOARDID};X-Amz-Meta-Boardtitle=${BOARDTITLE};"
    A5="X-Amz-Meta-Cardid=${CARDID};X-Amz-Meta-Cardtitle=${CARDTITLE};"
    A6="X-Amz-Meta-Swimlaneid=${SWIMLANEID};X-Amz-Meta-Swimlanetitle=${SWIMLANETITLE};"
    A7="X-Amz-Meta-Listid=${LISTID};X-Amz-Meta-Listtitle=${LISTTITLE};"
    A8="X-Amz-Meta-Userid=${USERID};X-Amz-Meta-Username=${USERNAME};X-Amz-Meta-Fullname=${FULLNAME};"
    A9="X-Amz-Meta-Emails=${EMAILS};"
    A10="X-Amz-Meta-Filetype=${FILETYPE};X-Amz-Meta-Filetype=${FILEEXTENSION}"
    #echo "$SWIMLANEID"
#    UPLOADMINIO=$(echo "mc mv \"${OBJECTID}\" \"${MINIOBUCKETNAME}/${FILEDIR}/${FINALFILENAME}\" --attr \"$A1$A2$A3$A4$A5$A6$A7$A8$A9$A10\"")
    #echo "$UPLOADMINIO"
    #echo "mv mv ${FINALFILENAME} ${MINIOBUCKETNAME}/${FILEDIR}/${FINALFILENAME} --attr \"$A1$A2$A3$A4$A5$A7$A8$A9\""
    echo -e "$A1\n\n$A2\n\n$A3\n\n$A4\n\n$A5\n\n$A7\n\n$A8\n\n$A9\n\n$A19\n\n" > "files2/${FINALFILENAME}.txt"
    #echo "$CARDID $CARDTITLE"
    #$A4$A5$A6$A7$A8
    #echo mc mv "${FINALFILENAME}" "${MINIOBUCKETNAME}/${FILEDIR}/${FINALFILENAME}" --attr "$A1$A2$A3$A4$A5$A7$A8"
    #UPLOADMINIO=$(echo mc mv "${FINALFILENAME}" "${MINIOBUCKETNAME}/${FILEDIR}/${FINALFILENAME}" --attr "$A1$A2$A3$A4$A5$A6$A7$A8")
#    eval $UPLOADMINIO
    #echo "File number: ${FILENUMBER} / ${MAXFILECOUNT}"
  done
}

#function listfiles() {
#  mongofiles --host ${MONGOHOST} --port ${MONGOPORT} -d ${MONGODBNAME} --prefix=$FILECOLL list
#}

# 1) Transfer attachments
##FILEDIR=attachments
##FILECOLL=cfs_gridfs.attachments
##FILECOLLFILES=cfs_gridfs.attachments.files
##FILERECORD=cfs.attachments.filerecord
##transfer
FILECOLL=attachments
FILECOLLFILES=attachments.files
FILERECORD=attachments.filerecord
transfer

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
