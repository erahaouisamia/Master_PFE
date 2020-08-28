#!/bin/bash -e
sudo killall apt apt-get
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*
sudo dpkg --configure -a
sudo apt update -y
sudo apt install python3.7 -y
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
sudo apt install python3-pip -y
sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt update -y
sudo apt install ansible -y
#K8S_VERSION=$(kubectl version --kubeconfig /home/ubuntu/kubernetes.conf | base64 | tr -d '\n')
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$K8S_VERSION" --kubeconfig /home/ubuntu/kubernetes.conf
