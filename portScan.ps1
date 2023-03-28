<# 
.SYNOPSIS
    Portscan that prints the ping responce to a text file: hostname.txt

.DESCRIPTION
    The Portscan is used to scan a r
 
.NOTES
    Run in default powershell.

.COMPONENT 
    Information about PowerShell Modules to be required.

.LINK
    github.com/spuzzelsnest
 
.Parameter ParameterName
    $ip     - is used to define the first 3 octets of the IP range wich is used to run the script. It searches from 1 to 254 via a ping scan through the IP addresses.
#>




$ipRange = read-host "What IP range to scan - Give the first 3 octets: \n"

Write-Host $ipRange

