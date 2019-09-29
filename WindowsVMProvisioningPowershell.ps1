#1 - Start connection with Azure
Connect-AzureRmAccount -Subscription 'Pay-As-You-Go'

#2 - Get existing resource group created in your subscription and store it into a variable
$rg = Get-AzureRmResourceGroup `
    -Name 'playground-demo-rg' `
    -Location 'northeurope'

$rg 

#3 - Create a new subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig `
    -Name 'playground-subnet-2' `
    -AddressPrefix '10.2.1.0/24' `

$subnetConfig

#4 - Create a virtual network and create the defined subnet on this network
$vnet = New-AzureRmVirtualNetwork `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'playground-vnet-2' `
    -AddressPrefix '10.2.0.0/16' `
    -Subnet $subnetConfig
$vnet

#5 - Create a public IP Address 
$pip = New-AzureRmPublicIpAddress `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'playground-windows-publicip-2' `
    -AllocationMethod Static

$pip

#6 - Create network security group, with the newly created rule
$nsg = New-AzureRmNetworkSecurityGroup `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'playground-windows-nsg-2'

$nsg

#7 - Create the virtual network interface and associate with public IP and NSG
$subnet = $vnet.subnets | Where-Object { $_.Name -eq $subnetConfig.Name }

$nic = New-AzureRmNetworkInterface `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Name 'playground-windows-nic-2' `
    -Subnet $subnet `
    -PublicIpAddress $pip `
    -AzureRmNetworkSecurityGroup $nsg

$nic

#8 - Define username & password of the VM, so we actually create a PSCredential object, this will be used for the Windows username/password
$password = ConvertTo-SecureString 'Password123#' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ('demoadmin', $password)

#8.1 - Defined all the configuration data needed to create the VM. 
$vmParams = @{
    ResourceGroupName = $rg.Name
    Name = 'playground-windows-vm-2'
    Location = 'northeurope'
    Size = 'Standard_D1'
    Image = 'Win2016Datacenter'
    PublicIpAddressName = $pip.Name
    Credential = $WindowsCred
    VirtualNetworkName = $vnet.Name
    SubnetName = $subnet.Name
    SecurityGroupName = $nsg.Name
    OpenPorts = 3389
}

#8.2 - This is the only command needed to now create the Azure VM. "vmParams" are being as configuration for VM creation.
New-AzVm @vmParams
