#!/bin/bash

docker-compose up -d

echo "Configuring config server"
docker-compose exec config01 sh -c "mongo --port 27017 < /scripts/init-configserver.js" > /dev/null

echo "Configuring shard 01"
docker-compose exec shard01a sh -c "mongo --port 27018 < /scripts/init-shard01.js" > /dev/null

echo "Configuring shard 02"
docker-compose exec shard02a sh -c "mongo --port 27019 < /scripts/init-shard02.js" > /dev/null

echo "Configuring shard 03"
docker-compose exec shard03a sh -c "mongo --port 27020 < /scripts/init-shard03.js" > /dev/null

echo "Waiting for dust to settle..."
sleep 20
echo "Configuring routers"
docker-compose exec router01 sh -c "mongo < /scripts/init-router.js" > /dev/null
docker-compose exec router02 sh -c "mongo < /scripts/init-router.js" > /dev/null
docker-compose exec router03 sh -c "mongo < /scripts/init-router.js" > /dev/null
