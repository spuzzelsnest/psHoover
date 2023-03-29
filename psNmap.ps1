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

$ifList = Get-NetAdapter | ?{ $_.Status -eq "Up" }

$ownIP = (Get-NetIPAddress -InterfaceIndex $ifList[0].ifIndex).IPAddress
$ipRange = (($ownIP.Split(".")|select -First 3) -join ".")+"."
Write-Host $ifList.count " Networkadapter(s) found.`n"$ifList[0].Name" with IP $ownIP `nRunnig ping sweep on range "$ipRange"1/24`n"
Clear-Content -Path .\hostname.txt
For ($i = 1; $i -lt 254; $i++) {

            $ip = $ipRange+$i

            if( Test-Connection -count 1 -comp $ip -quiet ){
                $ip | Out-File -Append -FilePath .\hostname.txt
            } 
}

write-host "Scann donen content of hostname.txt"
Get-Content .\hostname.txt