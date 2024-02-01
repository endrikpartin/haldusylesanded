# Küsi kasutajalt ees- ja perenimi
$firstName = Read-Host "Sisesta kasutaja eesnimi"
$lastName = Read-Host "Sisesta kasutaja perenimi"

# Moodusta kasutajanimi ees.perenimi kujul
$username = "$($firstName.ToLower()).$($lastName.ToLower())"

# Proovi kustutada kasutaja
try {
    Remove-LocalUser -Name $username -ErrorAction Stop
    Write-Host "Kasutaja $username kustutati edukalt."
} catch {
    Write-Host "Viga kasutaja kustutamisel: $_"
}
