const Minio = require('minio');
const express = require('express');
const app = express();
const port = 7000;

// Initialize a new Minio client
const minioClient = new Minio.Client({
  endPoint: '127.0.0.1',
  key: 'your-access-key',
  secret: 'your-secret-key',
  bucketName: 'store',
  port: 9000,
  useSSL: false
})

// Set the bucket and object name for the image you want to view
const bucketName = 'store';
const objectName = 'image.png';

let data;

app.get('/', (req, res) => {
  minioClient.getObject(bucketName, objectName, (err, objStream) => {
    if (err) {
      return console.log(err)
    }
    objStream.on('data', function(chunk) {
      data = !data ? new Buffer(chunk) : Buffer.concat([data, chunk]);
    })
    objStream.on('end', function() {
      res.writeHead(200, {'Content-Type': 'image/jpeg'});
      res.write(data);
      res.end();
    })
    objStream.on('error', function(err) {
      res.status(500);
      res.send(err);
    })
  });
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})


/*

// List all object paths in bucket my-bucketname.
/*
app.get('/', (req, res) => {

var objectsStream = minioClient.listObjects(bucketName, '', true)
objectsStream.on('data', function(obj) {
  res.write(obj)
})
objectsStream.on('error', function(e) {
  res.write(e)
})



var size = 0
// Get a full object.
minioClient.getObject(bucketName, objectName, function(e, dataStream) {
  if (e) {
    return console.log(e)
  }
  dataStream.on('data', function(chunk) {
    size += chunk.length
  })
  dataStream.on('end', function() {
    console.log("End. Total size = " + size)
  })
  dataStream.on('error', function(e) {
    console.log(e)
  })
})

if (err) {
      return res.status(404).send(err)
    }
    res.set('Content-Type', 'image/jpeg')
    dataStream.pipe(res)
  })
})

*/

/*
  if (err) {
    return console.log(err)
  }
  dataStream.on('data', function(chunk) {
    size += chunk.length
  })
  dataStream.on('end', function() {
    console.log("End. Total size = " + size)
  })
  dataStream.on('error', function(err) {
    console.log(err)
  })
})
*/


/*
// Retrieve the image as a stream
const stream = minioClient.getObject(bucketName, objectName)

// Set the Content-Type header of the response to the correct MIME type for the image
res.setHeader('Content-Type', 'image/jpeg')

// Pipe the image stream to the response object
stream.pipe(res)
*/

// Presigned get object URL for my-objectname at my-bucketname, it expires in 7 days by default.
//var presignedUrl = s3Client.presignedGetObject('my-bucketname', 'my-objectname', 1000, function(e, presignedUrl) {


/*
var presignedUrl = minioClient.presignedGetObject(bucketName, objectName, 60, function(e, presignedUrl) {
  if (e) return console.log(e)
  console.log(presignedUrl)
})
*/


//app.get('/image', (req, res) => {
