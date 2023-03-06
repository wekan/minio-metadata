const { MongoClient } = require("mongodb");
const { spawn } = require('child_process');
const { uri, dbname } = require('./settings.json');

const client = new MongoClient(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

function getfilerecord(attachment) {
  const filerecord = spawn('node', ['filerecord.js', attachment._id]);
  filerecord.stdout.on('data', (data) => {
    console.log(`${data}`);
  });
}

async function run(collection, query, options) {
  try {
    await client.connect();
    const database = client.db(dbname);
    const files = database.collection(collection);
    const cursor = files.find(query, options);
    //return cursor;
    await cursor.forEach(attachment => {
      //console.log(attachment);
      //const filerecord = toka(attachment._id);
      //attachment.filerecord = filerecord;
      console.log("{ file: ", attachment, ",");
      getfilerecord(attachment);
      //const board = getboard

/*
      attachment.filerecord_id = filerecord._id;
      attachment.original = filerecord.original;
      attachment.boardId = filerecord.boardId;
      attachment.swimlaneId = filerecord.swimlaneId;
      attachment.listIdId = filerecord.listId;
      attachment.userId = filerecord.userId;
      attachment.uploadedAt = filerecord.uploadedAt;
      attachment.copies = filerecord.copies;
*/

    });
    // print a message if no documents were found
    if ((await cursor.count()) === 0) {
      console.log("No documents found!");
    }
  } finally {
    await client.close();
  }
}

/*
async function run2() {
  try {
    await client2.connect();
    const database2 = client2.db(dbname);
    const query2 = { 'copies.attachments.key': attachment._id };
    const options2 = {};
    const filerecords = database2.collection("cfs.attachments.filerecord");
    const filerecord = await filerecords.findOne(query2, options2);
    return filerecord;
  } finally {
    await client.close();
  }
}
*/
const collection = "cfs_gridfs.attachments.files";
const query = {};
const options = {};
run(collection, query, options).catch(console.dir);


/*
const collection2 = "cfs.attachments.filerecord";
const query2 = { 'copies.attachments.key': attachment._id };
const options2 = {};
run(collection2, query2, options2).catch(console.dir);
*/


//run2().catch(console.dir);


/*
    attachment.filerecord_id = filerecord._id;
    attachment.original = filerecord.original;
    attachment.boardId = filerecord.boardId;
    attachment.swimlaneId = filerecord.swimlaneId;
    attachment.listIdId = filerecord.listId;
    attachment.userId = filerecord.userId;
    attachment.uploadedAt = filerecord.uploadedAt;
    attachment.copies = filerecord.copies;
    console.log(attachment);
*/

