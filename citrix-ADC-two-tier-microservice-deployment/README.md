## Learn how to deploy Citrix ADC in two tier microservices topology using MInikube


Citrix ADC offers the two-tier architecture deployment solution to load balance the enterprise grade applications deployed in microservices and access it from outside kubernetes cluster. Tier 1 Citrix ADC routes the traditional North-South traffic and VPX/SDX/MPX can act as your Tier 1 ADC, whereas CPX (containerized Citrix ADC) act as Tier 2 ADC and route the East-West traffic. We are going deploy microservices using yaml files located in yaml-files folder.

![two-tier-deployment](https://user-images.githubusercontent.com/42699135/53289454-1e1b5d80-37bc-11e9-9a53-08e7bcbc646b.PNG)

Here are the detailed demo steps for tier 1 and tier 2 microservice deployment using Minikube.
1. Install the Minikube on the VM or laptop
Please refer to (https://github.com/mayurpatil11/Minikube-example-Citrix-ADC-microservice-deployment#how-do-i-setup-minikube-for-deploying-microservices) for installing minikube and proceed with next step.

If you want to deploy yamls using kubernetes dashboard, then please refer to below note.
Note:
Set up a Kubernetes dashboard for deploying containerized applications.
Please visit https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/ and follow the steps mentioned to bring the Kubernetes dashboard up as shown below.

###Pre-requisites:-
Network Configuration on Ingress NetScaler Device:-
Ingress NetScaler (Tier 1 ADC) should be able to reach pods running in Minikube cluster therefore Network configuration is required for seamless communication from client to microservices. Hence, we have to add CNI network route information into the VPX. 
Steps to add route information in VPX:-
a. Do SSH login in minikube cluster and execute ``ifconfig``
b. Look for CNI network IP, I have used weave network here,
![weave_networkip](https://user-images.githubusercontent.com/42699135/53314538-d9d7ac80-38e4-11e9-80ae-ba516a2058e5.PNG)
c. login to VPX and execute add route command refer to below command
![add_route](https://user-images.githubusercontent.com/42699135/53314608-4a7ec900-38e5-11e9-9778-58646935df58.PNG)

You can read more about network configuration on ingress NetScaler device from https://github.com/citrix/citrix-k8s-ingress-controller/blob/master/docs/network-config.md

  
2. Create a namespaces using minikube SSH console.
```
kubectl create namespace tier-2-adc
kubectl create namespace team-colddrink
```
3. Copy the yaml files from ``Minikube-example-Citrix-ADC-microservice-deployment/citrix-ADC-two-tier-microservice-deployment/yaml-files/`` to minikube node ``/root/yamls`` directory
4. Deploy the ``rbac.yaml`` in the default namespace to provide access to kubernetes resources
```
kubectl create -f /root/yamls/rbac.yaml 
```
5. Deploy the CPX as tier 2 ADC to route the traffic from Tier 1 to microservices using following commands,

```
kubectl create -f /root/yamls/cpx-svcacct.yaml -n tier-2-adc
kubectl create -f /root/yamls/cpx.yaml -n tier-2-adc
kubectl create -f /root/yamls/hotdrink-secret.yaml -n tier-2-adc
```
Note: hotdrink-secret.yaml contains the SSL certificate and key to allow secure North-South traffic.
6. Deploy the colddrink beverage microservice using following commands
```
kubectl create -f /root/yamls/team_colddrink.yaml -n team-colddrink
kubectl create -f /root/yamls/colddrink-secret.yaml -n team-colddrink
```
Note: colddrink-secret yaml file contains SSL certificate and key required to secure the communication from tier 1 ADC to colddrink microservice.
7. Login to Tier 1 ADC (VPX/SDX/MPX appliance) to verify no (CS/LB)configuration is present before we automate the Tier 1 ADC.
8. Deploy the VPX ingress and ingress controller to push the CPX configuration into the tier 1 ADC automatically.
**Note:-** 
Go to ``ingress_vpx.yaml`` and change the IP address of ``ingress.citrix.com/frontend-ip: "x.x.x.x"`` annotation to one of the free IP which will act as content switching vserver for accessing microservices.
e.g. ``ingress.citrix.com/frontend-ip: "10.105.158.160"``
Go to ``cic_vpx.yaml`` and change the NS_IP value to your VPX NS_IP.         
``- name: "NS_IP"
  value: "x.x.x.x"``
Now execute the following commands after the above change.
```
kubectl create -f /root/yamls/ingress_vpx.yaml -n tier-2-adc
kubectl create -f /root/yamls/cic_vpx.yaml -n tier-2-adc
```
9. Add the DNS entry in your local machine host files for accessing microservices though internet.
Path for host file: ``C:\Windows\System32\drivers\etc\hosts``
Add below entries in hosts file and save the file

```
<frontend-ip from ingress_vpx.yaml> colddrink.beverages.com
```
10. Now colddrink microservice is ready to be served outside kubernetes cluster.
e.g. Goto your browser and access ``https://colddrink.beverages.com``
