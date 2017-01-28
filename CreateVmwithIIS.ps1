configuration CreateADDomainWithData
{ 
   param 
   ( 
        [Parameter(Mandatory)]
        [String]$computername = 'localhost'

       
    ) 
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xStorage

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("$DomainName\$($AdminCreds.UserName)", $AdminCreds.Password)

    Node $AllNodes.NodeName
    {
        LocalConfigurationManager
        {
            ActionAfterReboot = 'ContinueConfiguration'
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
            AllowModuleOverWrite = $true
        }

        xWaitforDisk Disk2
        {
             DiskNumber = 2
             RetryIntervalSec =$RetryIntervalSec
             RetryCount = $RetryCount
        }

        xDisk IISDataDisk
        {
            DiskNumber = 2
            DriveLetter = 'F'
        }

        WindowsFeature IIS 
        { 
            Ensure = 'Present'
            Name = 'Web-Server'
        }  

        WindowsFeature ASP
        { 
            Ensure = 'Present' 
            Name = 'Web-Asp-Net45' 
        }

   }
}
