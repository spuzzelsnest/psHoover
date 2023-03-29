<# 
.SYNOPSIS
    Portscan that prints the ping responce to a text file: hostname.txt

.DESCRIPTION
    The Portscan is used to scan a range of ports
 
.NOTES
    Run in default powershell.

.COMPONENT 
    Information about PowerShell Modules to be required.

.LINK
    github.com/spuzzelsnest
 
.Parameter ParameterName
    $ip     - is used to define the first 3 octets of the IP range wich is used to run the script. It searches from 1 to 254 via a ping scan through the IP addresses.
#>

# env
$ErrorActionPreference = "silentlycontinue"

# Vars
$ifList = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
$ownIP = (Get-NetIPAddress -InterfaceIndex $ifList[0].ifIndex).IPAddress
$ipRange = (($ownIP.Split(".")|Select-Object -First 3) -join ".")+"."
$port = 22

Write-Host $ifList.count "Networkadapter(s) found.`n"$ifList[0].Name"with IP $ownIP `nRunnig ping sweep on range "$ipRange"1/24"
Clear-Content -Path .\hostname.txt

For ($i = 50; $i -lt 70; $i++) {

            $ip = $ipRange+$i

            if( Test-Connection -count 1 -comp $ip -quiet ){
                $ip | Out-File -Append -FilePath .\hostname.txt
            } 
}

"Scan done content of hostname.txt`n...Starting port scan ..."

$ips = Get-Content .\hostname.txt

foreach ($ip in $ips){
    write-host "found:  $ip"
    If(Test-Connection -BufferSize 32 -Count 1 -Quiet -ComputerName $ip){
        $socket = New-Object System.Net.Sockets.TcpClient($ip, $port)
        If($socket.Connected) {
            "$ip port $port open"
            $socket.Close()
        }else{
            
            "$ip port $port not open"
        }
    }
}