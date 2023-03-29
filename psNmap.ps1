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
$TCPports = @(20,21,22,23,53,80,443,445,3389,4444,8080)
$ips = @()
$openPorts = @{}

Write-Host $ifList.count "Networkadapter(s) found.`n"$ifList[0].Name"with IP $ownIP `nRunnig ping sweep on range "$ipRange"1/24"
Clear-Content -Path .\hostname.txt

# Running ping scan on default range from 1 to 254 

For ($i = 1; $i -lt 254; $i++) {
    $ip = $ipRange+$i
    if ($ip -eq $ownIP){
        Write-Debug "removing own IP"
    }else{
        if ( Test-Connection -count 1 -comp $ip -quiet ){
            $ips += $ip
        }
    } 
}

"... Starting port scan on $TCPports ..."

foreach ($ip in $ips){
    write-host "found:  $ip"
    foreach ($TCPport in $TCPports){
        If(Test-Connection -BufferSize 32 -Count 1 -Quiet -ComputerName $ip){
            $socket = New-Object System.Net.Sockets.TcpClient($ip, $TCPport)
            If($socket.Connected) {
                Write-Host "$ip port $TCPport open" -ForegroundColor Green
                $openPorts.Add($ip,$TCPport) 
                $socket.Close()
            }else{
                Write-Host "$ip port $TCPport not open" -ForegroundColor Red
            }
        }
    }
}

$openPorts