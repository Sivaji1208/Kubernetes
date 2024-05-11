#!/bin/bash

sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
az account set -s e7948db7-f07a-4d41-8c51-52b3f8e44f9f
az group create --name k8s-lab-rg3 --location canadacentral
az network vnet create --name k8s-lab-vnet --resource-group k8s-lab-rg3 --location canadacentral --address-prefixes 172.10.0.0/16 --subnet-name k8s-lab-net1 --subnet-prefixes 172.10.1.0/24

RG=k8s-lab-rg3
LOCATION=canadacentral
SUBNET=$(az network vnet show --name k8s-lab-vnet -g $RG --query subnets[0].id -o tsv)

# Master instances
echo "Creating Kubernetes Master"
az vm create --name kube-master \
   --resource-group $RG \
   --location $LOCATION \
   --image Ubuntu2204 \
   --admin-user azureuser \
   --generate-ssh-keys \
   --size Standard_DS2_v2 \
   --data-disk-sizes-gb 10 \
   --subnet $SUBNET \
   --public-ip-address-dns-name kube-master-lab

# Nodes intances

az vm availability-set create --name kubeadm-nodes-as --resource-group $RG

for i in 0 1 2; do
    echo "Creating Kubernetes Node ${i}"
    az vm create --name kube-node-${i} \
       --resource-group $RG \
       --location $LOCATION \
       --availability-set kubeadm-nodes-as \
       --image Ubuntu2204 \
       --admin-user azureuser \
       --generate-ssh-keys \
       --size Standard_DS2_v2 \
       --data-disk-sizes-gb 10 \
       --subnet $SUBNET \
       --public-ip-address-dns-name kube-node-lab-${i}
done

az vm list --resource-group $RG -d