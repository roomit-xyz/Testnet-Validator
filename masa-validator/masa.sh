#!/bin/bash


MASA_VERSION="v1.0"
MASA_TAGS="v1.03"
MASA_NAME="masa-node"
MASA="${MASA_NAME}-${MASA_VERSION}"
SOURCE_MASA="${HOME}/MASA"


if ! [ -d ${HOME}/MASA ]
then
   mkdir -p ${HOME}/MASA
fi

cd ${HOME}/MASA

if ! [ -f ${HOME}/MASA/"${MASA}-${MASA_TAGS}".tar.gz ]
then
   wget -c https://github.com/masa-finance/masa-node-v1.0/archive/refs/tags/${MASA_TAGS}.tar.gz -O "${MASA}-${MASA_TAGS}".tar.gz
   _name_packages=`tar tf "${MASA}-${MASA_TAGS}".tar.gz | head -n1 | tr -d "/"`
   tar xvf "${MASA}-${MASA_TAGS}".tar.gz 
   mv ${_name_packages} ${MASA}
   ln -sf ${HOME}/MASA/${MASA} ${HOME}/MASA/${MASA_NAME}
fi

cd ${HOME}/MASA/${MASA_NAME}
cp -rf ${SOURCE_MASA}/docker/docker-compose.yml  ${HOME}/MASA/${MASA_NAME}/
cp -rf ${SOURCE_MASA}/docker/docker-compose-ui.yml  ${HOME}/MASA/${MASA_NAME}/ui/
cp -rf ${SOURCE_MASA}/docker/re-run.sh  ${HOME}/MASA/${MASA_NAME}/
mkdir -p ${HOME}/MASA/${MASA_NAME}/masa-storage
bash -x re-run.sh
