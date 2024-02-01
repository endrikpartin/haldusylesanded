# Küsi kasutajalt ees- ja perenimi
$firstName = Read-Host "Sisesta kasutaja eesnimi"
$lastName = Read-Host "Sisesta kasutaja perenimi"

# Moodusta kasutajanimi ees.perenimi kujul
$username = "$($firstName.ToLower()).$($lastName.ToLower())"

# Kontrolli, kas kasutaja juba eksisteerib AD-s
if (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue) {
    Write-Host "Kasutaja '$username' on juba olemas Active Directory's."
} else {
    # Loo uus kasutaja AD-s
    $displayName = "$firstName $lastName"
    $password = ConvertTo-SecureString "Parool1!" -AsPlainText -Force
    $userParams = @{
        SamAccountName = $username
        DisplayName = $displayName
        UserPrincipalName = "$username@example.com"
        Name = $displayName
        AccountPassword = $password
        Enabled = $true
    }
    try {
        New-ADUser @userParams
        Write-Host "Kasutaja '$username' loodi edukalt Active Directory's."
    } catch {
        Write-Host "Viga kasutaja loomisel: $_"
    }
}
