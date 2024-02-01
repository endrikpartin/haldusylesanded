# Funktsioon, mis teisendab teksti ladina tähestikust sõltumatuks
function ConvertTo-LatinCharacters {
    param(
        [string]$text
    )

    $normalized = $text.Normalize([Text.NormalizationForm]::FormKD)
    $builder = New-Object -Type System.Text.StringBuilder

    $normalized.ToCharArray() | ForEach-Object {
        if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark') {
            [void]$builder.Append($_)
        }
    }

    $builder.ToString().ToLower()
}

# Küsi kasutajalt ees- ja perenimi
$firstName = Read-Host "Sisesta kasutaja eesnimi"
$lastName = Read-Host "Sisesta kasutaja perenimi"

# Moodusta kasutajanimi ees.perenimi kujul, kasutades transliit-funktsiooni
$username = (ConvertTo-LatinCharacters ($firstName + "." + $lastName)).Replace(" ", "")

# Proovi kustutada kasutaja
try {
    Remove-ADUser -Identity $username -Confirm:$false -ErrorAction Stop
    Write-Host "Kasutaja $username kustutati edukalt Active Directory's."
} catch {
    if ($_.Exception.Message -match "cannot be found") {
        Write-Host "Kasutajat '$username' ei leitud Active Directory's."
    } else {
        Write-Host "Viga kasutaja kustutamisel: $_"
    }
}
