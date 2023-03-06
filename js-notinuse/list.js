const { MongoClient } = require("mongodb");
const { uri, dbname } = require('./settings.json');

const client = new MongoClient(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

async function run() {
  try {
    await client.connect();
    const database = client.db(dbname);
    const filerecords = database.collection("lists");
    const query = { '_id': process.argv[2] };
    const options = {};
    const filerecord = await filerecords.findOne(query, options);
    console.log(filerecord, ',');
  } finally {
    await client.close();
  }
}
run().catch(console.dir);
