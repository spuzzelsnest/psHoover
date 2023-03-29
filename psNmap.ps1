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
$ports = @(22,80,443)
$ips = @()

Write-Host $ifList.count "Networkadapter(s) found.`n"$ifList[0].Name"with IP $ownIP `nRunnig ping sweep on range "$ipRange"1/24"
Clear-Content -Path .\hostname.txt

# Running ping scan on default range from 1 to 254 

For ($i = 1; $i -lt 254; $i++) {
    $ip = $ipRange+$i
    if( Test-Connection -count 1 -comp $ip -quiet ){
        $ips += ,$ip
    } 
}

"Scan done content of hostname.txt`n...Starting port scan on $ports ..."

foreach ($ip in $ips){
    write-host "found:  $ip"
    foreach ($port in $ports){
        If(Test-Connection -BufferSize 32 -Count 1 -Quiet -ComputerName $ip){
            $socket = New-Object System.Net.Sockets.TcpClient($ip, $port)
            If($socket.Connected) {
                Write-Host "$ip port $port open" -ForegroundColor Green
                $socket.Close()
            }else{
                write-host "$ip port $port not open" -ForegroundColor Red
            }
        }
    }
}