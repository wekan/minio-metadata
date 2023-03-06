var Minio = require('minio');
const { MongoClient } = require('mongodb');
const { uri, dbname, minioClient } = require('./settings.json');


// Instantiate the minio client with the endpoint
// and access keys as shown below.
var minioClient = new Minio.Client(minioClient);


async function main() {
  // Use connect method to connect to the server
  await client.connect();
  console.log('Connected successfully to server');
  const db = client.db(dbName);
  const collection = db.collection('users');

  //const findResult = await collection.find({}).toArray();
  const findResult = await collection.findOne({});
  console.log('Found documents =>', findResult);

  // the following code examples can be pasted here...

  return 'done.';
}

main()
  .then(console.log)
  .catch(console.error)
  .finally(() => client.close());

*/

// File that needs to be uploaded.
var file = 'Computer.jpeg'

//    'Content-Type': 'application/octet-stream',

var metaData = {
    'Content-Type': 'image/jpeg',
    'X-Amz-Meta-Testing': 1234,
    'example': 5678
}

minioClient.fPutObject('wekan', file, file, metaData, function(err, etag) {
  if (err) return console.log(err)
  console.log('File uploaded successfully.')
});
