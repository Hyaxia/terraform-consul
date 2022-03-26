Steps to run:

- run `chmod +x init_env.sh` to enable execution of the init script
- run `./init_env.sh`
- run `terraform apply`
- - to check if we can access the golang webapp run `minikube tunnel` and try to access `http://127.0.0.1/` and `http://127.0.0.1/webapp/test`
- - to check the consul dashboard run `minikube service consul-consul-ui -n consul`

---

TODO:

- add postgres deployment and set the webapp to interact withit
- add consul as service mesh
- read article about using helm with kubernetes https://medium.com/@ayanendude/terraform-ing-application-on-kubernetes-cluster-7c3a7357c5dc

postgres kube terraform module

- https://registry.terraform.io/modules/ballj/postgresql/kubernetes/latest
