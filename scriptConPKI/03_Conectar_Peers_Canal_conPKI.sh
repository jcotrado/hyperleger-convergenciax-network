# Copyright ConvergenciaX Spa.
# Autor: Joel Cotrado Vargas <joel.cotrado@gmail.com>
# Date: 01-12-2022
#
# Se crea conection a docker CLI y conectan peers de la organización al canal
#

#Conectar docker CLI y ejecutar los siguientes comandos
docker exec -ti -e CHANNEL_NAME=marketplace cli /bin/bash
 
# Ejecutar creación de canal y relacionarlo a la primera organizacion
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp

#export FABRIC_CFG_PATH=/opt/gopath/src/github.com/hyperledger/fabric/peer
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp
export CLIENTAUTH_CERTFILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/tls/server.crt
export CLIENTAUTH_KEYFILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/tls/server.key
export CORE_PEER_LOCALMSPID=Org1MSP
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/convergenciax.com/orderers/orderer.convergenciax.com/tls/ca.crt



echo "************************************************************************"
echo "crear marketplace.block y unir a Org1MSP"
echo "************************************************************************"

echo "CORE_PEER_MSPCONFIGPATH     [$CORE_PEER_MSPCONFIGPATH]"
echo "CORE_PEER_ADDRESS           [$CORE_PEER_ADDRESS]"
echo "CORE_PEER_LOCALMSPID        [$CORE_PEER_LOCALMSPID]"
echo "CORE_PEER_TLS_ROOTCERT_FILE [$CORE_PEER_TLS_ROOTCERT_FILE]"

echo "CA_FILE                     [$CA_FILE]"
#########33333
#CREAR CANAL
#########33333
peer channel create -o orderer.convergenciax.com:7050 -c marketplace -f ./channel-artifacts/channel.tx --outputBlock ./channel-artifacts/marketplace.genesis.block --tls --cafile $ORDERER_CA --clientauth --certfile $CLIENTAUTH_CERTFILE --keyfile $CLIENTAUTH_KEYFILE



export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp



#agregar la primera organizacioon Org1MSP, donde usa los valores de las varables $CORE_PEER_MSPCONFIGPATH, $CORE_PEER_ADDRESS, $CORE_PEER_LOCALMSPID y CORE_PEER_TLS_ROOTCERT_FILE
peer channel join -b ./channel-artifacts/marketplace.genesis.block

###
#agregar la seguna y tercera organizacioon0 Org2MSP y Org3MSP, al canal
###
export CORE_PEER_ADDRESS=peer0.org2.convergenciax.com:7051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org2.convergenciax.com/peers/peer0.org2.convergenciax.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org2.convergenciax.com/users/admin@org2.convergenciax.com/msp

peer channel join -b ./channel-artifacts/marketplace.genesis.block

export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/users/admin@org3.convergenciax.com/msp

peer channel join -b ./channel-artifacts/marketplace.genesis.block
