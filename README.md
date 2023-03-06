# Transfer files from MongoDB GridFS to Minio

1. Edit settings.sh

2. `./start.sh`

This will:

1. Export MongoDB text to wekan.sqlite (Temporary .csv files at directory csv/ )

2. Export file from MongoDB GridFS to current directory

3. Upload file to Minio

4. Delete file from current directory, to not fill more disk space.

5. Go back to step 2. for each file

TODO:

- Add metadata to minio. All that metadata is also at wekan.sqlite, so it could be also added later.
