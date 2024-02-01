# Küsi kasutajalt ees- ja perenimi
$firstName = Read-Host "Sisesta oma eesnimi"
$lastName = Read-Host "Sisesta oma perenimi"

# Moodusta kasutajanimi ees.perenimi kujul
$username = "$($firstName.ToLower()).$($lastName.ToLower())"

# Kontrolli, kas kasutaja juba eksisteerib
if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
    # Loo uus lokaalne kasutaja parooliga "Parool1!"
    try {
        New-LocalUser -Name $username -Password (ConvertTo-SecureString "Parool1!" -AsPlainText -Force) -Description "Kasutaja: $($firstName) $($lastName)"
        Write-Host "Kasutaja $username loodi edukalt."
    } catch {
        Write-Host "Viga kasutaja loomisel: $_"
    }
} else {
    Write-Host "Kasutaja '$username' on juba olemas."
}
