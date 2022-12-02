#!/bin/bash


helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add bitnami https://charts.bitnami.com/bitnami

# start minikube cluster
minikube start

# add the option to add an ingress to the minikube cluster
# minikube addons enable ingress

# change docker envrinvoment variables to perform all of the actions on the minikube docker
eval $(minikube docker-env)

# build the needed images
docker build --rm -t golang-docker-example ./test_app
docker build --rm -t gateway ./gateway

# init terraform
terraform init