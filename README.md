Steps to run:

- run `minikube start`
  - starts the local kubernetes cluster
  - using version v1.24.0, commit 76b94fb3c4e8ac5062daf70d60cf03ddcc0a741b
- run `minikube addons enable ingress`
- run `eval $(minikube docker-env)`
  - lets minikube using the local docker daemon
  - detailed explanation - https://stackoverflow.com/questions/52310599/what-does-minikube-docker-env-mean
- now we can build the docker images and minikube will be able to access them
  - run `docker build --rm -t golang-docker-example ./test_app`
  - run `docker build --rm -t gateway ./gateway`
- run `terraform init`
- run `terraform apply`
- - to check if we can access the golang webapp run `minikube tunnel` and try to access `http://127.0.0.1/`

---

TODO:

- read article about using helm with kubernetes https://medium.com/@ayanendude/terraform-ing-application-on-kubernetes-cluster-7c3a7357c5dc
