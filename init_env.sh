#!/bin/bash


helm repo add hashicorp https://helm.releases.hashicorp.com

# enable execution of pf.sh script
chmod +x ./vitess/pf.sh

# start minikube cluster
minikube start --kubernetes-version=v1.19.16 --cpus=4 --memory=7000 --disk-size=64g

# add the option to add an ingress to the minikube cluster
# minikube addons enable ingress

# change docker envrinvoment variables to perform all of the actions on the minikube docker
eval $(minikube docker-env)

# build the needed images
docker build --platform linux/amd64 --rm -t my-vitess-mysqld ./vitess
docker build --rm -t golang-docker-example ./test_app
docker build --rm -t gateway ./gateway

# init terraform
terraform init