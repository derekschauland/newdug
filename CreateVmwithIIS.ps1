configuration CreateVMwithIIS
{
         node "localhost"
        {
            WindowsFeature IIS
            {
                    Ensure = "Present"
                    Name = "Web-Server"
            }
        
            windowsfeature AspNet45
            {
                ensure = "present"
                name = "Web-Asp-Net45"
               
            }
        }
}