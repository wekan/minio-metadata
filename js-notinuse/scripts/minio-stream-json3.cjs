#!/usr/bin/env node
// minio 8.0.7, the newest minio, still asks for stream-json ^1.8.0, and every
// stream-json below 3.6.0 is vulnerable (GHSA-528h-pc64-c93x,
// GHSA-hqr4-qq8f-hg3x, GHSA-mjw6-4jj6-33hc). package.json overrides
// stream-json to 3.x, which renamed jsonl/Parser.js to jsonl/parser.js and
// replaced Parser.make() with parser.asStream(). minio loads that file at
// startup (listenBucketNotification), so without this patch require('minio')
// throws "Cannot find module .../stream-json/src/jsonl/Parser.js".
//
// Both return a stream of {key, value} objects, one per JSON line, so the
// patch only changes where the parser comes from. Run as postinstall; it is
// idempotent, and it fails loudly when minio's code no longer matches, so a
// newer minio is noticed instead of silently left broken.
'use strict';

const fs = require('fs');
const path = require('path');

let minioDir;
try {
  minioDir = path.dirname(require.resolve('minio/package.json'));
} catch (e) {
  process.exit(0); // minio not installed: nothing to patch
}

const patches = [
  {
    file: 'dist/main/notification.js',
    from: 'var _Parser = require("stream-json/jsonl/Parser.js");',
    to: 'var _Parser = { make: options => require("stream-json/jsonl/parser.js").default.asStream(options) };',
  },
  {
    file: 'dist/esm/notification.mjs',
    from: "import jsonLineParser from 'stream-json/jsonl/Parser.js';",
    to: "import jsonlParser from 'stream-json/jsonl/parser.js';\nconst jsonLineParser = { make: options => jsonlParser.asStream(options) };",
  },
];

let failed = false;
for (const { file, from, to } of patches) {
  const target = path.join(minioDir, file);
  if (!fs.existsSync(target)) continue;
  const src = fs.readFileSync(target, 'utf8');
  if (src.includes(to)) continue; // already patched
  if (!src.includes(from)) {
    console.error(`minio-stream-json3: ${file} of minio does not contain the expected stream-json import; check whether this patch is still needed.`);
    failed = true;
    continue;
  }
  fs.writeFileSync(target, src.replace(from, to));
  console.log(`minio-stream-json3: patched ${file} for stream-json 3`);
}
process.exit(failed ? 1 : 0);
