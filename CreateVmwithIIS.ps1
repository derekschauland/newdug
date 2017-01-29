configuration CreateVMwithIIS
{
         node "localhost"
        {
            WindowsFeature IIS
            {
                Ensure = "Present"
                Name = "Web-Server"
            }
        }
}