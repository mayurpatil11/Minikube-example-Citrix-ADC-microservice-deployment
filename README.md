# Learn how to deploy Citrix ADC in microservice deployment using Minikube

## How do I setup Minikube for deploying microservices
Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a VM on your laptop.
Minikube can be installed on OS, Windows or Linux OS. Please refere to https://kubernetes.io/docs/setup/minikube/#installation guide for complete Minikube setup.

Quick steps for installing Minikube on Ubuntu 16.04
1. Install hypervisor (Virtualbox)
```
sudo apt-get update
sudo apt remove virtualbox*
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo su
echo "deb https://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list
apt-get update
sudo apt-get install virtualbox virtualbox-ext-pac
```
2. Install Kubectl
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubectl
kubectl version
```
3. Install Minikube
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
sudo mv -v minikube /usr/local/bin
minikube version
exit
```
4. Start the Minikube with below command to enable support for CNI plugins
```
minikube start --network-plugin=cni --extra-config=kubelet.network-plugin=cni
```
5. Install CNI plugin (e.g. weave, Calico or Flannel) as per your requirment. Here I have installed weave CNI plugin using below commands
```
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
```
6. Test the Kubernetes service and deploy the microservices
```
kubectl get nodes
kubectl cluster-info
```

Please refer to ``citrix-ADC-two-tier-microservice-deployment`` and ``citrix-ADC-one-tier-microservice-deployment`` examples which will enable you to deploy Citrix ADC in North-South and East-West microservice deployment using minikube.
