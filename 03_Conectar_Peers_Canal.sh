# Copyright ConvergenciaX Spa.
# Autor: Joel Cotrado Vargas <joel.cotrado@gmail.com>
# Date: 01-12-2022
#
# Se crea conection a docker CLI y conectan peers de la organización al canal
#

#Conectar docker CLI y ejecutar los siguientes comandos
docker exec -ti -e CHANNEL_NAME=marketplace cli /bin/bash

#############################################################################
# Ejecutar creación de canal y conectar los 3 peers/ Organizaciones
#############################################################################

##
# Paso 1 - crear canal marketplace, asociado a Org1
##
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/users/Admin@org1.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt

echo $CORE_PEER_MSPCONFIGPATH
echo $CORE_PEER_ADDRESS
echo $CORE_PEER_LOCALMSPID
echo $CORE_PEER_TLS_ROOTCERT_FILE

#echo $CORE_PEER_TLS_CERT_FILE
#echo $CORE_PEER_TLS_KEY_FILE

peer channel create -o orderer.convergenciax.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/tlsca.convergenciax.com-cert.pem


####
# Paso 2 - agregar Org1 al canal marketplace, se deben configurar las variables de ambiente
####

# agregar la primera organizacioon Org1MSP, donde usa los valores de las varables $CORE_PEER_MSPCONFIGPATH, 
# $CORE_PEER_ADDRESS, $CORE_PEER_LOCALMSPID y CORE_PEER_TLS_ROOTCERT_FILE
# Ya tiene configurado las variables de ambiente CORE_PEER_MSPCONFIGPATHm CORE_PEER_ADDRESS, CORE_PEER_LOCALMSPID y 
# CORE_PEER_TLS_ROOTCERT_FILE que referencian a cada organizacion

 
 peer channel join -b marketplace.block

####
# Paso 3 - agregar Org2 al canal marketplace, se deben configurar las variables de ambiente $CORE_PEER_MSPCONFIGPATH,
# $CORE_PEER_ADDRESS, $CORE_PEER_LOCALMSPID y CORE_PEER_TLS_ROOTCERT_FILE para que se asuma la Organizacion 2.
#
####

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.convergenciax.com/users/Admin@org2.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org2.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.convergenciax.com/peers/peer0.org2.convergenciax.com/tls/ca.crt

peer channel join -b marketplace.block

####
# Paso 4 - agregar Org3 al canal marketplace, se deben configurar las variables de ambiente $CORE_PEER_MSPCONFIGPATH,
# $CORE_PEER_ADDRESS, $CORE_PEER_LOCALMSPID y CORE_PEER_TLS_ROOTCERT_FILE para que se asuma la Organizacion 3.
#
####
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/users/Admin@org3.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt

 peer channel join -b marketplace.block