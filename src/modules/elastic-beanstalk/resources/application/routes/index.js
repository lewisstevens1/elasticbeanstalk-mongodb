var express = require("express");
var router = express.Router();
const { MongoClient } = require("mongodb");

const uri =
  "mongodb://rds.local:27017/?directConnection=true&appName=mongosh+2.3.4";

router.get("/", async function (req, res, next) {
  try {
    const client = new MongoClient(uri, {
      connectTimeoutMS: 3000,
      serverSelectionTimeoutMS: 3000,
    });

    var connectionStatus = "No connection";

    try {
      await client.db("admin").command({ ping: 1 });
      connectionStatus = "Connected successfully to server";
    } finally {
      await client.close();
    }

    res.json({ data: connectionStatus });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
