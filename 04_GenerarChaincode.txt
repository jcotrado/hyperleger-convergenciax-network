# Copyright ConvergenciaX Spa.
# Autor: Joel Cotrado Vargas <joel.cotrado@gmail.com>
# Date: 01-12-2022
#
# Se crea chaincode llamado foodcontrol
#

#Conectar docker CLI y ejecutar los siguientes comandos
docker exec -ti -e CHANNEL_NAME=marketplace cli /bin/bash



##
#
# Se crea chaincode llamado foodcontrol, con operaciones Set y Query, el codigo esta en golang en
# carpeta ../chaincode/foodcontrol
#
# Se ejecuta comando en CLI
##

#####
#PASO1 - Generar paquete chaincode foodcontrol, aun no se instalan en las organizaciones
#####
export CHANNEL_NAME=marketplace
export CHAINCODE_NAME=foodcontrol
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/$CHAINCODE_NAME"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/tlsca.convergenciax.com-cert.pem
export VERBOSE=true

echo $CHANNEL_NAME
echo $CHAINCODE_NAME
echo $CHAINCODE_VERSION
echo $CC_RUNTIME_LANGUAGE
echo $CC_SRC_PATH

echo $ORDERER_CA
ls  -las $CC_RC_PATH
ls  -las $ORDERER_CA


peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION} >> log_instalar_${CHAINCODE_NAME}_${CHAINCODE_VERSION}.txt



#########
## PASO 2 - Instalando  foodcontrol en organizacion 1
###########

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/users/Admin@org1.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt

peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

#########
# Instalando  foodcontrol en organizacion 2
# Se requiere actalizar variables de ambiente 
###########

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.convergenciax.com/users/Admin@org2.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org2.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.convergenciax.com/peers/peer0.org2.convergenciax.com/tls/ca.crt

peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

#########
# Instalando  foodcontrol en organizacion 3
# Se requiere actalizar variables de ambiente 
###########

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/users/Admin@org3.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt

peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz



##
# PASO 3 - POLITICAS
# Se habiltian permisos a la 1ra y 3ra organizacion
##

## PACKAGE-ID es tomado del valor de "INFO 036 Chaincode code package identifier:" generado al momento de instalar el chaincode
export PACKAGEID=foodcontrol_1:8979aeeac8c436127011c73ee54042a2c1c4d4354626fe590f8b2838288f2f7f

## Primera organizacion
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/users/Admin@org1.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/tlsca.convergenciax.com-cert.pem

peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy  "OR ('Org1MSP.peer', 'Org3MSP.peer')" --package-id $PACKAGEID

## Remover permisos para la 2da

## 3ra organizacion

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/users/Admin@org3.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt

peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy  "OR ('Org1MSP.peer', 'Org3MSP.peer')" --package-id $PACKAGEID


 


###
#
# PASO 4  Autorizar cambios en permisos
# aplicar checkcommitreadiness y aprobar cambios (verificar)
#
###

peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy  "OR ('Org1MSP.peer', 'Org3MSP.peer')" --output json


###
#
# PASO 5  COMMIT DE POLITICAS de aprobacion para 1ra y 3ra Organizacion
#
# Se especifican los peer a los cuales se hace commit
###


peer lifecycle chaincode commit -o orderer.convergenciax.com:7050  --tls --cafile $ORDERER_CA  --peerAddresses peer0.org1.convergenciax.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt --peerAddresses peer0.org3.convergenciax.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy  "OR ('Org1MSP.peer', 'Org3MSP.peer')"

### Verificar estado canal

peer lifecycle chaincode  queryapproved --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --output json

###
#
# PASO 6  Invocar Chaincode food control
#
# Se especifican los peer a los cuales se hace commit
###

### Prueba 0rg1
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/users/Admin@org1.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/tlsca.convergenciax.com-cert.pem
peer chaincode invoke -o orderer.convergenciax.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME -c '{"Args":["Set","id:3","JoelCotradoOrg1","Pasteles"]}'

### Prueba 0rg3

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/users/Admin@org3.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt
peer chaincode invoke -o orderer.convergenciax.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME -c '{"Args":["Set","id:4","JoelOrg3","Paltas"]}'

###################
## prueba org2, falla por permisos, no los 
#############

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.convergenciax.com/users/Admin@org2.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org2.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.convergenciax.com/peers/peer0.org2.convergenciax.com/tls/ca.crt
peer chaincode invoke -o orderer.convergenciax.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME -c '{"Args":["Set","id:4","JoelOrg2","Paltas"]}'
