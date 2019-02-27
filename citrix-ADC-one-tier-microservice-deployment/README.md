## Learn how to deploy Citrix ADC in one tier microservices topology using Minikube
In Single Tier deployment mode the Tier-1 Citrix ADC load balances the microservices deployed in the minikube. Citrix ingress Controller is deployed in minikube which automates the configuration of CITRIX ADC(VPX/SDX/MPX) with the help of ingress resources which exposes these microservices.

![single-tier-topology](https://user-images.githubusercontent.com/42699135/53352427-bd6d5b80-3948-11e9-84f4-11568cd3b9e3.png)

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

2. Deploy the hotdrink microservice using following command
```
kubectl create -f hotdrink_app.yaml
```

3. Deploy the Citrix ingress controller to automate the Tier 1 ADC
```
kubectl create -f cic_vpx.yaml
```
Note:
Go to ``cic_vpx.yaml`` and change the NS_IP value to your VPX NS_IP.         
``- name: "NS_IP"
  value: "x.x.x.x"``
  
4. Deploy the VPX ingress which creates the Content switching policy in Tier 1 ADC
```
kubectl create -f ingress_hotdrink.yaml
```
Note: 
Go to ``ingress_hotdrink.yaml`` and change the IP address of ``ingress.citrix.com/frontend-ip: "x.x.x.x"`` annotation to one of the free IP which will act as content switching vserver for accessing microservices.
e.g. ``ingress.citrix.com/frontend-ip: "10.105.158.160"``

5. Add the DNS entries in your local machine host files for accessing microservices though internet.
Path for host file: ``C:\Windows\System32\drivers\etc\hosts``
Add below entries in hosts file and save the file,

<frontend-ip from ingress_vpx.yaml> hotdrink.beverages.com

6. Now your microservice is ready to access over internet
e.g. Goto browser and access ``http://hotdrink.beverages.com``

![hotbeverage_webpage](https://user-images.githubusercontent.com/42699135/50677394-987efb00-101f-11e9-87d1-6523b7fbe95a.png)


