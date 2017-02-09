#region Top Items
#break

# Shout out to @brwilkinson for assistance with some of this.


# Install the Azure Resource Manager modules from PowerShell Gallery
# Takes a while to install 28 modules
#Install-Module AzureRM -Force -Verbose
#Install-AzureRM

# Install the Azure Service Management module from PowerShell Gallery
#Install-Module Azure -Force -Verbose

# Import AzureRM modules for the given version manifest in the AzureRM module
#Import-AzureRM -Verbose

# Import Azure Service Management module
#Import-Module Azure -Verbose
#endregion

# Authenticate to your Azure account
Write-Host "Script Started at $(Get-Date)"
Import-Module AzureRM.profile
if (Get-AzureRmSubscription -SubscriptionId 0cff335b-e4a2-4bd7-a1c9-514d96399af8)
{
    Write-Host "Already signed into Azure"
}
else
{
    Login-AzureRmAccount
    
}

$URI       = 'https://raw.githubusercontent.com/derekschauland/newdug/master/azuredeploy.json'
$Location  = 'centralus'
$rgname    = 'test1'
#$saname    = 'newdugstoragefeb'     # Lowercase required here
#region
#$addnsName = 'atwposhad'     # Lowercase required

# Check that the public dns $addnsName is available
#if (Test-AzureRmDnsAvailability -DomainNameLabel $addnsName -Location $Location)
#{ 'DNS Name is Available' } else { 'Taken. addnsName must be globally unique.' }
#endregion
# Create the new resource group. Runs quickly.
New-AzureRmResourceGroup -Name $rgname -Location $Location
# Parameters for the template and configuration
$MyParams = @{
    #StorageAccountName         = $saname
    #location              = $location
    #domainName            = 'atwposh.local'
    #addnsName             = $addnsName
}

# Splat the parameters on New-AzureRmResourceGroupDeployment  
$SplatParams = @{
    TemplateUri             = $URI 
    ResourceGroupName       = $rgname 
    TemplateParameterObject = $MyParams
    Name                    = 'DeployThis'
   }

New-AzureRmResourceGroupDeployment @SplatParams -Verbose

# Find the VM IP and FQDN
$PublicAddress = (Get-AzureRmPublicIpAddress -ResourceGroupName $rgname)[0]
$IP   = $PublicAddress.IpAddress
$FQDN = $PublicAddress.DnsSettings.Fqdn

# RDP either way
Start-Process -FilePath mstsc.exe -ArgumentList "/v:$FQDN"
#region
#Start-Process -FilePath mstsc.exe -ArgumentList "/v:$IP"

# Login as:  atwposh\adadministrator
# Use the password you supplied at the beginning of the build. PowerShellDSC2016

# Explore the Active Directory domain:
#  Recycle bin enabled
#  Admin tools installed
#  Five new OU structures
#  Users and populated groups within the OU structures
#  Users root container has test users and populated test groups
#endregion
# Delete the entire resource group when finished
#$rgname = 'newdug'
#Remove-AzureRmResourceGroup -Name $rgname -Force -Verbose
