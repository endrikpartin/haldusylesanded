# Funktsioon juhusliku parooli genereerimiseks
function Generate-RandomPassword {
    param (
        [int]$length = 10
    )

    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
    $password = -join ((0..$length) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    return $password
}

# Küsi kasutajalt ees- ja perenimi
$firstName = Read-Host "Sisesta kasutaja eesnimi"
$lastName = Read-Host "Sisesta kasutaja perenimi"

# Moodusta kasutajanimi ees.perenimi kujul
$username = "$($firstName.ToLower()).$($lastName.ToLower())"

# Kontrolli, kas kasutaja juba eksisteerib AD-s
if (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue) {
    Write-Host "Kasutaja '$username' on juba olemas Active Directory's."
} else {
    # Loo juhuslik parool
    $password = Generate-RandomPassword -length 12

    # Loo uus kasutaja AD-s
    $displayName = "$firstName $lastName"
    $userParams = @{
        SamAccountName = $username
        DisplayName = $displayName
        UserPrincipalName = "$username@example.com"
        Name = $displayName
        AccountPassword = (ConvertTo-SecureString -String $password -AsPlainText -Force)
        Enabled = $true
    }
    try {
        New-ADUser @userParams
        Write-Host "Kasutaja '$username' loodi edukalt Active Directory's."

        # Salvesta kasutajatunnus ja parool CSV-faili
        $userDetails = [PSCustomObject]@{
            Kasutajanimi = $username
            Parool = $password
        }
        $userDetails | Export-Csv -Path "$username.csv" -NoTypeInformation
        Write-Host "Kasutaja andmed salvestati faili: $username.csv"
    } catch {
        Write-Host "Viga kasutaja loomisel: $_"
    }
}
