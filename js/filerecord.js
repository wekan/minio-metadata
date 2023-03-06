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

function getswimlane(swimlaneId) {
  const swimlane = spawn('node', ['swimlane.js', swimlaneId]);
  swimlane.stdout.on('data', (data) => {
    console.log(`swimlane: ${data}`);
  });
}

function getlist(listId) {
  const list = spawn('node', ['list.js', listId]);
  list.stdout.on('data', (data) => {
    console.log(`list: ${data}`);
  });
}

function getcard(cardId) {
  const card = spawn('node', ['card.js', cardId]);
  card.stdout.on('data', (data) => {
    console.log(`card: ${data}`);
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
    getswimlane(filerecord.swimlaneId);
    getlist(filerecord.listId);
    getcard(filerecord.cardId);
  } finally {
    await client.close();
  }
}
run().catch(console.dir);
