#1 - Authentication
az login

#2 - List the images in our Subscription
az image list --output table 

#3 - Let's say we started a new Resource Group in the East US Region
az group create `
    --name 'playground-demo-rg2' `
    --location 'eastus'

#4 - We need to get a copy of our image into that Azure Regions, we'll need the image copy extension, so we need to install it.
az extension add `
    --name image-copy-extension

#5 - Now as we have the image-copy-extension installed, we can copy images between regions.
#Process can take 5-10 minutes.
az image copy `
    --source-object-name "playground-windows-vm-image-1" `
    --source-resource-group 'playground-demo-rg' `
    --target-location 'eastus' `
    --target-resource-group 'layground-demo-rg2' `
    --cleanup

#6 - Let's try to create a VM from a custom image that's in another Azure Region
az vm create `
    --location 'eastus' `
    --resource-group 'playground-demo-rg2' `
    --name 'playground-vm-2' `
    --image 'playground-windows-vm-image-1' `
    --admin-username "demoadmin" `
    --admin-password "Password123456789#"