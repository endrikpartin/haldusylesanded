# Defineerime vajaliku k2surea parameetrid
param(
 $Kasutajanimi,
 $Taisnimi, 
 $KontoKirjeldus
 )
 # Loome kasutajale parooli
$KasutajaParool = ConvertTo-SecureString "qwerty" -AsPlainText -Force
 # Lisame kasutaja vastavate andmetega 
New-LocalUser "$Kasutajanimi" -Password $KasutajaParool -FullName "$TaisNimi" -Description "$KontoKirjeldus"