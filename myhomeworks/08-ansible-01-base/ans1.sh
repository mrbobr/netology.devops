#!/usr/bin/env bash

CName=$(cat containers.txt)

for i in ${CName[@]}
do
  echo -n "starting container: "
  docker start $i
  echo "container started"
  echo ""
done

ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass

for i in ${CName[@]}
do
  echo -n "stopping container: "
  docker stop $i
  echo "container stopped"
  echo ""
done