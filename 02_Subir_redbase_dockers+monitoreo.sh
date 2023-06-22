# Copyright ConvergenciaX Spa.
# Autor: Joel Cotrado Vargas <joel.cotrado@gmail.com>
# Date: 01-12-2022
#
# Se crea monitoreo con Portainer y sube red base de convergenciaX en dockers
#



export CHANNEL_NAME=marketplace
export VERBOSE=true
export FABRIC_CFG_PATH=/home/jcotrado/HLFconvergenciax/convergenciax-network

echo $CHANNEL_NAME
echo $VERBOSE
echo $FABRIC_CFG_PATH

CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d

