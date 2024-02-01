# Määra varunduste kausta asukoht
$backupFolder = "C:\Backup"

# Looge varunduste kaust, kui see puudub
if (-not (Test-Path -Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
}

# Hangi kõik kasutajad ja loo varukoopia nende kodukataloogist
$users = Get-ChildItem -Path "C:\Users" -Directory | Select-Object -ExpandProperty Name
$currentDate = Get-Date -Format "dd.MM.yyyy"

foreach ($user in $users) {
    $userBackupFile = Join-Path -Path $backupFolder -ChildPath "$user-$currentDate.zip"

    # Kontrolli, kas kasutaja kodukataloogi varund on juba olemas
    if (Test-Path -Path $userBackupFile) {
        Write-Host "Kasutaja $user kodukataloogi varund ($userBackupFile) on juba olemas."
    } else {
        $userFolder = Join-Path -Path "C:\Users" -ChildPath $user
        if (Test-Path -Path $userFolder) {
            Write-Host "Varundan kasutaja $user kodukataloogi..."

            # Looge zip-fail ja varunda kasutaja kodukataloog
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::CreateFromDirectory($userFolder, $userBackupFile)

            Write-Host "Varundatud fail: $userBackupFile"
        } else {
            Write-Host "Kasutajat $user kodukataloogi ei leitud."
        }
    }
}
