#!/bin/bash

HOME="/home/gneareth"


echo Your APP MASA in ${HOME}

if [ $UID -eq 0 ]
then
  read -p "Input your key Node : "  data
  length_count=`echo ${data} | wc -m`
  if [ $length_count == 65 ]
  then
     echo "${data}" | tee ${HOME}/MASA/masa-node/masa-storage/vol-01/dd/geth/nodekey
     docker restart masa-node-backend
  else
    echo "length not 64 character"
  fi
else
  echo "Make sure Running With ROOT"
fi
