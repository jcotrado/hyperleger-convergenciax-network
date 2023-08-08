function joinChannel() {
  org=$1
  mspID=$2
  peerAddress=$3

  export CORE_PEER_ADDRESS=$peerAddress
  export CORE_PEER_LOCALMSPID=$mspID
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_TLS_ROOTCERT_FILE=$(cd ../ && echo $PWD/pki-ca/$org/peers/peer0.$org/tls/ca.crt)
  export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/pki-ca/$org/users/admin@$org/msp)
  peer channel join -b ../channel-artifacts/marketplace.genesis.block
}

function updateChannelWithAnchorTx() {
    org=$1
    msp=$2
    peerAddress=$4

    export CORE_PEER_ADDRESS=$peerAddress
    export CORE_PEER_LOCALMSPID=$msp
    export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/pki-ca/$org/users/admin@$org/msp)
    export ORDERER_CA=$(cd ../ && echo $PWD/pki-ca/acme.com/orderers/orderer.convergenciax.com/tls/ca.crt)

    peer channel update -c marketplace -f ../channel-artifacts/${msp}anchors.tx -o localhost:7050 --tls --cafile $ORDERER_CA
}

which peer
if [ "$?" -ne 0 ]; then
    echo "peer tool not found. exiting"
    exit 1
fi

export FABRIC_CFG_PATH=$(cd ../ && pwd)
export CORE_PEER_MSPCONFIGPATH=$(cd ../ && echo $PWD/pki-ca/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp)
export CLIENTAUTH_CERTFILE=$(cd ../ && echo $PWD/pki-ca/org1.convergenciax.com/users/admin@org1.convergenciax.com/tls/server.crt)
export CLIENTAUTH_KEYFILE=$(cd ../ && echo $PWD/pki-ca/org1.convergenciax.com/users/admin@org1.convergenciax.com/tls/server.key)
export CORE_PEER_LOCALMSPID=Org1MSP
export ORDERER_CA=$(cd ../ && echo $PWD/pki-ca/acme.com/orderers/orderer.convergenciax.com/tls/ca.crt)
# Create the application channel
peer channel create -o localhost:7050 -c marketplace -f ../channel-artifacts/channel.tx --outputBlock ../channel-artifacts/marketplace.genesis.block --tls --cafile $ORDERER_CA --clientauth --certfile $CLIENTAUTH_CERTFILE --keyfile $CLIENTAUTH_KEYFILE
# Let the peers join the channel
joinChannel org1.convergenciax.com Org1MSP localhost:7051
joinChannel org2.convergenciax.com Org2MSP localhost:8051
joinChannel org3.convergenciax.com Org3MSP localhost:9051
# Set the anchor peers in the network
updateChannelWithAnchorTx org1.convergenciax.com Org1MSP localhost:7051
updateChannelWithAnchorTx org2.convergenciax.com Org2MSP localhost:8051
updateChannelWithAnchorTx org3.convergenciax.com Org3MSP localhost:9051
