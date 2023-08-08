# Copyright ConvergenciaX Spa.
# Autor: Joel Cotrado Vargas <joel.cotrado@gmail.com>
# Date: 01-04-2023
#
# Implementación de PKI externa
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
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/ca-cert.pem
export ORDERER_ADDRESS=orderer.convergenciax.com:7050
export CORE_PEER_TLS_ENABLED=true
export VERBOSE=true

echo $CHANNEL_NAME
echo $CHAINCODE_NAME
echo $CHAINCODE_VERSION
echo $CC_RUNTIME_LANGUAGE
echo $CC_SRC_PATH

echo $ORDERER_CA
ls  -las $CC_RC_PATH
ls  -las $ORDERER_CA

#
# NOTA: Solo se empaqueta, no se compila ni instala
#
#


peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION} >> log_instalar_${CHAINCODE_NAME}_${CHAINCODE_VERSION}.txt



###################################################################################
## PASO 2 - compilando  foodcontrol  e instalando en organizacion 1
###################################################################################

#
# NOTA: en esta primera instalacion del chaincode/smartcontract, aveces falla y se puede eliminar el archivo /chaincode/foodcontrol/go.sum para corregir,
#       este se regenera al compilar en esta primera instalacion.
#
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt

peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz


#########
# Instalando  foodcontrol en organizacion 2
# Se requiere actalizar variables de ambiente 
###########

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org2.convergenciax.com/users/admin@org2.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org2.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org2.convergenciax.com/peers/peer0.org2.convergenciax.com/tls/ca.crt


peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

#########
# Instalando  foodcontrol en organizacion 3
# Se requiere actalizar variables de ambiente 
###########

#2023-08-08 15:35:42.369 UTC [msp.identity] Sign -> DEBU 036 Sign: digest: B028797EB6DBCB7C540784DFA6A36057501539331CA793567D9C925AFEAD248F 
#2023-08-08 15:36:06.860 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 037 Installed remotely: response:<status:200 payload:"\nNfoodcontrol_1:1043dd22a2356d1219bebd317b7e9d5f18eb9b2ecaa5c88a372e7e218ca1207e\022\rfoodcontrol_1" > 
#2023-08-08 15:36:06.861 UTC [cli.lifecycle.chaincode] submitInstallProposal -> INFO 038 Chaincode code package identifier: foodcontrol_1:1043dd22a2356d1219bebd317b7e9d5f18eb9b2ecaa5c88a372e7e218ca1207e
#
# El valor de PACKAGEID se obtiene del log generado en la instalacion en Org1MSP
#
export PACKAGEID=foodcontrol_1:1043dd22a2356d1219bebd317b7e9d5f18eb9b2ecaa5c88a372e7e218ca1207e

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/users/admin@org3.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt

peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz



##################################################################################
# PASO 3 - POLITICAS
# Se habiltian permisos a la 1ra y 3ra organizacion
##################################################################################

## PACKAGE-ID es tomado del valor de "INFO 036 Chaincode code package identifier:" generado al momento de instalar el chaincode

export CC_PACKAGE_ID=foodcontrol_1:1043dd22a2356d1219bebd317b7e9d5f18eb9b2ecaa5c88a372e7e218ca1207e

## Primera organizacion
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt                                 
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/ca-cert.pem

peer lifecycle chaincode approveformyorg -o orderer.convergenciax.com:7050  --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('Org1MSP.peer','Org3MSP.peer')" --package-id $CC_PACKAGE_ID

## Remover permisos para la 2da

## 3ra organizacion

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/users/admin@org3.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt

peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy  "OR ('Org1MSP.peer', 'Org3MSP.peer')" --package-id $CC_PACKAGE_ID


 


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


peer lifecycle chaincode commit -o orderer.convergenciax.com:7050  --tls --cafile $ORDERER_CA  --peerAddresses peer0.org1.convergenciax.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt --peerAddresses peer0.org3.convergenciax.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy  "OR ('Org1MSP.peer', 'Org3MSP.peer')"

### Verificar estado canal

peer lifecycle chaincode  queryapproved --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --output json

###
#
# PASO 6  Invocar Chaincode food control
#
# Se especifican los peer a los cuales se hace commit
###

### Prueba 0rg1
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/users/admin@org1.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org1.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org1.convergenciax.com/peers/peer0.org1.convergenciax.com/tls/ca.crt
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/convergenciax.com/orderers/orderer.convergenciax.com/msp/tlscacerts/tlsca.convergenciax.com-cert.pem
peer chaincode invoke -o orderer.convergenciax.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME -c '{"Args":["Set","id:3","JoelCotradoOrg1","Pasteles"]}'

### Prueba 0rg3

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/users/admin@org3.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org3.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org3MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org3.convergenciax.com/peers/peer0.org3.convergenciax.com/tls/ca.crt
peer chaincode invoke -o orderer.convergenciax.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME -c '{"Args":["Set","id:4","JoelOrg3","Paltas"]}'

###################
## prueba org2, falla por permisos, no los 
#############

export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org2.convergenciax.com/users/admin@org2.convergenciax.com/msp
export CORE_PEER_ADDRESS=peer0.org2.convergenciax.com:7051
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/org2.convergenciax.com/peers/peer0.org2.convergenciax.com/tls/ca.crt
peer chaincode invoke -o orderer.convergenciax.com:7050 --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME -c '{"Args":["Set","id:4","JoelOrg2","Paltas"]}'
