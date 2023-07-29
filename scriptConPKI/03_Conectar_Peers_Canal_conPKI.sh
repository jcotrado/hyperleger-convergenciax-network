# Copyright ConvergenciaX Spa.
# Autor: Joel Cotrado Vargas <joel.cotrado@gmail.com>
# Date: 01-12-2022
#
# Se crea conection a docker CLI y conectan peers de la organización al canal
#

#Conectar docker CLI y ejecutar los siguientes comandos
docker exec -ti -e CHANNEL_NAME=marketplace cli /bin/bash
 
# Ejecutar creación de canal y relacionarlo a la primera organizacion
#export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/users/Admin@org1.convergenciax.com/msp
#export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt

export CA_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/ca-cert.pem

echo "************************************************************************"
echo "crear marketplace.block y unir a Org1MSP"
echo "************************************************************************"

echo "CORE_PEER_MSPCONFIGPATH     [$CORE_PEER_MSPCONFIGPATH]"
echo "CORE_PEER_ADDRESS           [$CORE_PEER_ADDRESS]"
echo "CORE_PEER_LOCALMSPID        [$CORE_PEER_LOCALMSPID]"
echo "CORE_PEER_TLS_ROOTCERT_FILE [$CORE_PEER_TLS_ROOTCERT_FILE]"

echo "CA_FILE                     [$CA_FILE]"

## export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/users/Admin@org1.convergenciax.com/msp
## export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
## export CORE_PEER_LOCALMSPID="Org1MSP"
## export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt
##
## peer channel create -o orderer.convergenciax.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/tlsca.convergenciax.com-cert.pem


peer channel create -o orderer.convergenciax.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile $CA_FILE

#agregar la primera organizacioon Org1MSP, donde usa los valores de las varables $CORE_PEER_MSPCONFIGPATH, $CORE_PEER_ADDRESS, $CORE_PEER_LOCALMSPID y CORE_PEER_TLS_ROOTCERT_FILE
 
 
peer channel join -b marketplace.block


#agregar la seguna y tercera organizacioon0 Org2MSP y Org3MSP,
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org2.convergenciax.com/users/admin@org2.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org2.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org2.convergenciax.com/peers/peer0.org2.convergenciax.com/tls/ca.crt

peer channel join -b marketplace.block

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/users/admin@org3.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt

 peer channel join -b marketplace.block
