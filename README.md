# Learn how to deploy Citrix ADC in microservice deployment using Minikube

## How do I setup Minikube for deploying microservices
Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a VM on your laptop.
Minikube can be installed on OS, Windows or Linux OS. Please refere to https://kubernetes.io/docs/setup/minikube/#installation guide for complete Minikube setup.

Install Minikube on Ubuntu VM using the custom script.

***Note:-*** We have developed the in-house script for bringing the Minikube on Ubuntu VM. This smart script is an alternative to virtualbox installation and zero error prone due to no dependencies on virtualbox. Script will install following componends;
a. Docker
b. Minikube
c. kubectl
d. Curl
If any of the above applications are present then script will prompt for upgrade option. ***This script will run only on Ubuntu VM.***


1. Copy the ``minikube-script.sh`` script located in /install-Minikube/ folder and save it in your VM under ``/root/`` repository

2. Give the full permission to execuatble script
```
chmod +x minikube-script.sh
```
3. Run the file and Minikube will be up and running seamlessly.
```
./minikube-script.sh
```

4. Check the status of master node and proceed with the application deployment
```
kubectl get nodes
```

Please download this example repository (which contains yaml files) from the ***clone or download*** option, required for demonstrating cloud native examples.
Please refer to ``citrix-ADC-two-tier-microservice-deployment`` and ``citrix-ADC-one-tier-microservice-deployment`` examples which will enable you to deploy Citrix ADC in North-South and East-West microservice deployment using minikube.

More details on Citrix ingress controller is located here- https://github.com/citrix/citrix-k8s-ingress-controller
