Steps to run:

- run `chmod +x init_env.sh` to enable execution of the init script
- run `./init_env.sh`
- run `terraform apply`
- - to check if we can access the golang webapp run `minikube tunnel` and try to access `http://127.0.0.1/` and `http://127.0.0.1/webapp/test`
- - to check the consul dashboard run `kubectl --namespace consul port-forward service/consul-consul-ui 18500:80 --address 0.0.0.0` and access `http://localhost:18500`
- - to check if the backend works run `kubectl port-forward service/backend -n tfs 8080:8080 --address 0.0.0.0` and access `http://localhost:8080`

---

current problem:
after injecting consul to the gateway it stopped receiving requests...
i've tried to perform tunnel and make a request to the gateway and I dont see anything in the logs,
but still i get an error from nginx, bad gateway, not sure if its the pods or the ingress

conclusion:
after trying different things that did not amount to any success, i think the best thing to do will be to remove all of the deployments and start with the smallest example possible.
also, follow the guides from hashicorp on how to setup consul with their example and then migrate it to mine

another thing is that it seems that terraform is not pretty good at creating kubernetes deployments, atleast not as good as helm is. so what I should do is learn how to package the deployments of the services into helm packages and then deploy them using terraform.
that will allow me to follow the guides in a more precise way and hopefully get it to work

TODO:

- add postgres deployment and set the webapp to interact withit

postgres kube terraform module

- https://registry.terraform.io/modules/ballj/postgresql/kubernetes/latest
