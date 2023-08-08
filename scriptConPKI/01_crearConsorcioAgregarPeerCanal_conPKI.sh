# Copyright ConvergenciaX Spa.
# Autor: Joel Cotrado Vargas <joel.cotrado@gmail.com>
# Date: 01-12-2022
#
# Se crea bloque genesys y material cryptografico para las 3 organizaciones base.
#

export FABRIC_CFG_PATH=/home/jcotrado/HLFconvergenciax/convergenciax-network
echo "FABRIC_CFG_PATH:[$FABRIC_CFG_PATH]"

export CHANNEL_NAME=marketplace
echo "CHANNEL_NAME:[$CHANNEL_NAME]"

rm -rf $FABRIC_CFG_PATH/crypto-config
rm -rf $FABRIC_CFG_PATH/channel-artifacts
#
#Realizar cambios requeridos para uso de configtxgen
#
cp configtx_conPKI.yaml configtx.yaml

echo "************************************************************************"
echo "crear Material Cryptografico"
echo "************************************************************************"
#cryptogen generate --config ./crypto-config.yaml

echo "************************************************************************"
echo "crear bloque Genesis, para perfil ThreeOrgsOrdererGenesis"
echo "************************************************************************"

configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block -configPath $FABRIC_CFG_PATH


echo "************************************************************************"
echo "crear canal marketplace"
echo "************************************************************************"

configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME -configPath $FABRIC_CFG_PATH


echo "************************************************************************"
echo "crear anchor peear en canal marketplace"
echo "************************************************************************"
#configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/${msp}anchors.tx -channelID marketplace    -asOrg $msp 
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP -configPath $FABRIC_CFG_PATH
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP -configPath $FABRIC_CFG_PATH
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP -configPath $FABRIC_CFG_PATH





