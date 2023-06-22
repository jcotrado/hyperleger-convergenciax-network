# Copyright ConvergenciaX Spa.
# Autor: Joel Cotrado Vargas <joel.cotrado@gmail.com>
# Date: 01-12-2022
#
# Se crea monitoreo con Portainer y sube red base de convergenciaX en dockers
#
<<<<<<< HEAD
docker volume create portainer_data
#docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
# docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ee:latest
docker run -d -p 8000:8000 -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
# password "admin.123456"
# cambiar password de portain
# docker run --rm httpd:2.4-alpine htpasswd -nbB admin "admin.123456" | cut -d ":" -f 2
#
=======

>>>>>>> 30fbe758ef1a972dba3414f43b9ff8cc38555697


export CHANNEL_NAME=marketplace
export VERBOSE=true
export FABRIC_CFG_PATH=/home/jcotrado/HLFconvergenciax/convergenciax-network

echo $CHANNEL_NAME
echo $VERBOSE
echo $FABRIC_CFG_PATH

CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d

