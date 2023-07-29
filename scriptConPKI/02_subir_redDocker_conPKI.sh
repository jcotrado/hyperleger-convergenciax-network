export CHANNEL_NAME=marketplace
export VERBOSE=true
export FABRIC_CFG_PATH=/home/jcotrado/HLFconvergenciax/convergenciax-network

echo $CHANNEL_NAME
echo $VERBOSE
echo $FABRIC_CFG_PATH

CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb_conPKI.yaml up -d

