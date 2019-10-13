#1 - Start connection with Azure
Connect-AzureRmAccount

#2.1 - Find our Resource Group
$rg = Get-AzureRmResourceGroup `
    -Name 'playground-demo-rg' `
    -Location 'northeurope'

#2.2 - Find our VM in our Resource Group
$vm = Get-AzureRmVm `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name 'playground-vm-1'

#2.3 - Deallocate the virtual machine
Stop-AzureRmVM `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name $vm.Name `
    -Force

#3 - Mark the virtual machine as "Generalized"
Set-AzureRmVm `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name $vm.Name `
    -Generalized

#4 - Start an Image Configuration from our source Virtual Machine $vm
$image = New-AzureRmImageConfig `
    -Location $rg.Location `
    -SourceVirtualMachineId $vm.ID

#4.1 - Create the actual image
New-AzureRmImage `
    -ResourceGroupName $rg.ResourceGroupName `
    -Image $image `
    -Imagename 'playground-windows-vm-image-1'

#4.2 - Get newly created image
Get-AzureRmImage `
    -ResourceGroupName $rg.ResourceGroupName


