configuration CreateVMwithIIS
{ 
   param 
   ( 
        [Parameter(Mandatory)]
        [String]$computername = 'localhost'

       
    ) 
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration
 

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

            WindowsFeature Management {
 
            Name = 'Web-Mgmt-Service'
            Ensure = 'Present'
            DependsOn = @('[WindowsFeature]IIS')
        }
 
        Registry RemoteManagement {
            Key = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server'
            ValueName = 'EnableRemoteManagement'
            ValueType = 'Dword'
            ValueData = '1'
            DependsOn = @('[WindowsFeature]IIS','[WindowsFeature]Management')
       }
 
       Service StartWMSVC {
            Name = 'WMSVC'
            StartupType = 'Automatic'
            State = 'Running'
            DependsOn = '[Registry]RemoteManagement'
 
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
