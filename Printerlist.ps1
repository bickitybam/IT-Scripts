############################################################################# 
# Exporting, Printer Name, IP Address, Driver from print server to a CSV file 
# 
# Rahmatullah Fedayizada 
# CIS Assistant 
# Mobile: 0796660969 
# Email: rahmat_fedayizada@hotmail.com 
# ============================================================================ 
 
## Put your own print server name 
 
$printserver = "server.FQDN.com" 
Get-WMIObject -class Win32_Printer -computer $printserver | Select Name,Caption,Comment,DriverName,Location,PortName,ShareName | Export-CSV -path '\\server\share\Printerlist.csv'