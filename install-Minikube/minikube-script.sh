#!/bin/bash
usage()
{
  echo "usage: ./ubuntu_minikube.sh [[[-t | --token token file with token for quay access] [[-g | --github Raw Github links to yaml files for the application deployment ] | [-l | --local List of directories with yamls to be deployed]]] | [-h]]"
}

base64value=""
file=""
deployment_flag=0
folder_list=0
file_list=0
token_flag=0

# Getting consent.
echo -e "\e[40m\e[96mCPX-INGRESS INSTALLER WITH MINIKUBE"
echo "Following applications along with their dependencies will be installed on your system if it is not present:"
echo "1. Docker"
echo "2. Minikube"
echo "3. kubectl"
echo "4. Curl"
echo -e "5. Unzip \e[0m"
while true; do
	read -p "Do you want to continue? Y/N > " to_continue
    case $to_continue in
        [Yy]* ) 
				consent=1
				rm -rf .citrix_minikube/
				mkdir .citrix_minikube
				cd .citrix_minikube/
				break
				;;
        [Nn]* ) exit 0;;
        * ) echo -e "\e[101mPlease enter Yes/No. \e[0m";;
    esac
done


# Making sure that minikube is not installed
reinstall=1
host=`minikube status 2>&1 | awk 'FNR == 1' | awk '{print $2}'`
kubelet=`minikube status 2>&1 | awk 'FNR == 2' | awk '{print $2}'`
apiserver=`minikube status 2>&1 | awk 'FNR == 3' | awk '{print $2}'`
kubectl=`minikube status 2>&1 | awk 'FNR == 4' | awk '{print $2}'`
if [[ "$host" = "Running" ]] && [[ "$kubelet" = "Running" ]] && [[ "$apiserver" = "Running" ]] && [[ "$kubectl" = "Correctly" ]]; then
	echo "The minikube system seems to be up and running correctly."
	while true; do
	    read -p "Do you want to reinstall? Y/N > " yn
	    case $yn in
	        [Yy]* ) reinstall=1
					break;;
	        [Nn]* ) reinstall=0
					break;;
	        * ) echo -e "\e[101mPlease enter Yes/No. \e[0m";;
	    esac
	done
fi

if [[ $reinstall -eq 1 ]]; then
	# Checking if docker is already installed and asking if they want to continue if installed
	install=0
	if [ -x "$(command -v docker)" ]; then
	    echo -e "\e[101mDocker is already installed. Do you want to update docker or continue with the already installed docker?\e[0m U/C "
	    while true; do
		    read -p "Do you wish to Update/Continue? > " yn
		    case $yn in
		        [Uu]* ) install=1
						break;;
		        [Cc]* ) install=0
						break;;
		        * ) echo -e "\e[101mPlease enter Update/Continue. \e[0m";;
		    esac
		done
	else
	    install=1
	fi

	# Checking if kubectl is already installed and asking if they want to continue if installed
	install_kubectl=0
	if [ -x "$(command -v kubectl)" ]; then
	    echo -e "\e[101mKubectl is already installed. Do you want to update kubectl or continue with the already installed kubectl?\e[0m U/C "
	    while true; do
		    read -p "Do you wish to Update/Continue? > " yn
		    case $yn in
		        [Uu]* ) install_kubectl=1
						break;;
		        [Cc]* ) install_kubectl=0
						break;;
		        * ) echo -e "\e[101mPlease enter Update/Continue. \e[0m";;
		    esac
		done
	else
	    install_kubectl=1
	fi

	# Install some of the required softwares
	sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common;

	# Downloading and installing the minikube binary
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64;
	sudo install minikube-linux-amd64 /usr/local/bin/minikube;
	# chmod +x minikube;
	# sudo cp minikube /usr/local/bin && rm minikube;

	# Installing Docker
	if [[ $install -eq 1 ]]; then
		sudo apt-get -y remove docker docker-engine docker.io containerd runc;
		sudo apt-get -y update;
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -;
		sudo apt-key fingerprint 0EBFCD88;
		sudo add-apt-repository \
		   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		   $(lsb_release -cs) \
		   stable";
		sudo apt-get -y update;
		sudo apt-get -y install docker-ce docker-ce-cli containerd.io;
	fi

	# Installing kube control
	if [[ $install_kubectl -eq 1 ]]; then
		sudo snap install kubectl --classic;
	fi

	# Starting minikube with no driver because in Ubuntu we can run docker without any Virtual drivers
	if [[ "$host" = "Running" ]]; then
		minikube stop
	fi
	minikube start --vm-driver=none;
fi

# =================================================== MINIKUBE INSTALLATION DONE! ===================================================
