az login

#1 - Create a resource group, then query the list of resource groups in our subscriptions
az group create `
 --name playground-demo-rg `
 --location northeurope

#1.1 - Confirm that the resource group was created, list all resource groups in the subscription. 
 az group list -o table

 #2 - Create virtual network (vnet) and subnet in one shot
 az network vnet create `
   --resource-group "playground-demo-rg" `
   --name "playground-vnet-1" `
   --address-prefix "10.1.0.0/16" `
   --subnet-name "playground-subnet-1" `
   --subnet-prefix "10.1.1.0/24"

#2.1 - Confirm that the vnet was created, list all vnets in the subscription. 
az network vnet list --output table

#3 - Create public IP address
az network public-ip create `
  --resource-group "playground-demo-rg" `
  --name "playground-windows-publicip"

#4 - Create network security group
az network nsg create `
  --resource-group "playground-demo-rg" `
  --name "playground-windows-nsg-1" `

#4.1 - Confirm that the nsg was created, list all nsg in the subscription. 
az network nsg list --output table

#5 - Create a virtual network interface and associate with public IP address and NSG
az network nic create `
  --resource-group "playground-demo-rg" `
  --name "playground-windows-nic-1" `
  --vnet-name "playground-vnet-1" `
  --subnet "playground-subnet-1" `
  --network-security-group "playground-windows-nsg-1" `
  --public-ip-address "playground-windows-publicip" `

#5.1 - Confirm that the network interface was created, list all network interfaces in the subscription. 
az network nic list --output table

#6 - Create a virtual machine
az vm create `
  --resource-group "playground-demo-rg" `
  --location "northeurope" `
  --name "playground-vm-1" `
  --nics "playground-windows-nic-1" `
  --image "win2016datacenter" `
  --admin-username "demoadmin" `
  --admin-password "Password123456789#"

#7 - Open port 3389 to allow RDP traffic to host
az vm open-port `
  --port "3389" `
  --resource-group "playground-demo-rg" `
  --name "playground-vm-1"

#7.1 - See "Public IP" address of newly created VM

az vm list-ip-addresses --name "playground-vm-1" --output table






