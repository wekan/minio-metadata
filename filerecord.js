const { MongoClient } = require("mongodb");
const { uri, dbname } = require('./settings.json');
const { spawn } = require('child_process');

const client = new MongoClient(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

function getboard(boardId) {
  const board = spawn('node', ['board.js', boardId]);
  board.stdout.on('data', (data) => {
    console.log(`board: ${data}`);
  });
}

async function run() {
  try {
    await client.connect();
    const database = client.db(dbname);
    const filerecords = database.collection("cfs.attachments.filerecord");
    const query = { 'copies.attachments.key': process.argv[2] };
    const options = {};
    const filerecord = await filerecords.findOne(query, options);
    console.log('filerecord:', filerecord, ',');
    getboard(filerecord.boardId);
  } finally {
    await client.close();
  }
}
run().catch(console.dir);
