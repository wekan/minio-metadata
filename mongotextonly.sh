#!/bin/bash

source settings.sh

db=$MONGODBNAME
out_dir=temptemp
if [ ! $out_dir ]; then
        out_dir="./"
else
        mkdir -p $out_dir
fi

tmp_file="fadlfhsdofheinwvw.js"
echo "print('_ ' + db.getCollectionNames())" | grep -v .chunks > $tmp_file
cols=`mongosh $MONGODBNAME --host $MONGOHOST --port $MONGOPORT $tmp_file | grep '_' | awk '{print $2}' | tr ',' ' '`
for c in $cols
do
    mongodump -d $MONGODBNAME --host $MONGOHOST --port $MONGOPORT -c $c
done
rm $tmp_file
