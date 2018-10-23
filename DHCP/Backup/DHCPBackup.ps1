#DHCP Export from 2008, import into 2012 R2 (run from 2012 R2 server):
#Export-DhcpServer –ComputerName SBSDC -Leases -File C:\export\dhcpexp.xml –verbose
#Import-DhcpServer –ComputerName DC -Leases –File C:\export\dhcpexp.xml -BackupPath C:\dhcp\backup\ -Verbose


$filedate = $(get-date).ToString("yyyy_MM_dd-hh-mm-ss")
Export-DhcpServer -Leases -File C:\dhcp\backup\dhcp-$filedate.xml -verbose