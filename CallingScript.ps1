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

# Authenticate to your Azure account
Import-Module AzureRM.profile
if (Get-AzureRmSubscription -SubscriptionId 0cff335b-e4a2-4bd7-a1c9-514d96399af8)
{
    Write-Host "Already signed into Azure"
}
else
{
    Login-AzureRmAccount
    
}

# Adjust the 'yournamehere' part of these three strings to
# something unique for you. Leave the last two characters in each.
$URI       = 'https://raw.githubusercontent.com/derekschauland/newdug/master/azuredeploy.json'
$Location  = 'centralus'
$rgname    = 'newdugrg'
$saname    = 'newdugsa'     # Lowercase required here
#$addnsName = 'atwposhad'     # Lowercase required

# Check that the public dns $addnsName is available
#if (Test-AzureRmDnsAvailability -DomainNameLabel $addnsName -Location $Location)
#{ 'DNS Name is Available' } else { 'Taken. addnsName must be globally unique.' }

# Create the new resource group. Runs quickly.
New-AzureRmResourceGroup -Name $rgname -Location $Location
#Set-AzureRmResourceGroup -Name $rgname -Tag @{AutoShutdownSchedule ="00:30 -> 22:00"} #Set tag for auto off schedule

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
    Name                    = 'newdugdemo'
   }

# This takes ~30 minutes
# One prompt for the domain admin password
New-AzureRmResourceGroupDeployment @SplatParams -Verbose

# Find the VM IP and FQDN
$PublicAddress = (Get-AzureRmPublicIpAddress -ResourceGroupName $rgname)[0]
$IP   = $PublicAddress.IpAddress
$FQDN = $PublicAddress.DnsSettings.Fqdn

# RDP either way
Start-Process -FilePath mstsc.exe -ArgumentList "/v:$FQDN"
#Start-Process -FilePath mstsc.exe -ArgumentList "/v:$IP"

# Login as:  atwposh\adadministrator
# Use the password you supplied at the beginning of the build. PowerShellDSC2016

# Explore the Active Directory domain:
#  Recycle bin enabled
#  Admin tools installed
#  Five new OU structures
#  Users and populated groups within the OU structures
#  Users root container has test users and populated test groups

# Delete the entire resource group when finished
#$rgname = 'newdugrg'
#Remove-AzureRmResourceGroup -Name $rgname -Force -Verbose
