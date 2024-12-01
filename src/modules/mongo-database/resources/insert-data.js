// Insert data with a new timestamp everytime the box launches

var document = {
  title: "document_title",
  timestamp: new Date(),
};

db.MyCollection.insert(document);
