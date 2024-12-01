#! /bin/bash

# Config repo
echo '[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc' > /etc/yum.repos.d/mongodb-org-8.0.repo

# Create data file
echo 'var document = {
  title: "document_title",
  timestamp: new Date(),
};

db.MyCollection.insertOne(document);' > /insert-data.js


# Install MongoDB
sudo yum install -y mongodb-mongosh-shared-openssl3
sudo yum install -y mongodb-org

# Edit mongo configuration
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

# Start service
sudo systemctl start mongod

# Insert test data using mongoshell (delay to wait for service to start)
sleep 10
mongosh 127.0.0.1/db /insert-data.js
