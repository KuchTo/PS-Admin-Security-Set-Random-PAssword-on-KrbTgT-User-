# Script zur randomisierten Passwortänderung des zentralen Users krb , um Golden Ticket Angriffe zu vermeiden.
# Powershell Skript Erstellt von Tobias Kuch
# Dieses Script auf KEINEN Fall in kürzen Abständen als mindestens 10 Stunden ausführen !

$Version = "1.0"
# Bugs, Ideen, Anmerkungen: keine

clear-host
$AnzahlZeichen        = 40
$KeineSonderzeichen   = $false  
$KeineZahlen          = $false
$KeineKleinbuchstaben = $false
$KeineGrossbuchstaben = $false

Import-Module ActiveDirectory  
# Defintion Zeichensatz
$Zeichen = @()
if ($KeineGrossbuchstaben -eq $false) { $Zeichen += 65..90  | ForEach-Object {[char] $_} }
if ($KeineKleinbuchstaben -eq $false) { $Zeichen += 97..122 | ForEach-Object {[char] $_} }
if ($KeineZahlen          -eq $false) { $Zeichen += 0..9    | ForEach-Object { $_ }      }
if ($KeineSonderzeichen   -eq $false) { '!"§$%&/()=?*+#.,-_;:' -split '' | ForEach-Object { $Zeichen += $_ } }
if ($Zeichen.count -eq 0) 
    {
    Write-Host "Der Zeichensatz darf nicht leer sein!" -ForegroundColor Magenta
    break
    }
# stelle Passwort zusammen
$PWD = (1..$AnzahlZeichen | ForEach-Object { Get-Random -InputObject $Zeichen -Count 1 }) -join ''

# Setze neues Passwort  
$UsrDNPath = "CN=krbtgt,CN=Users," + (Get-ADDomain).DistinguishedName

Set-ADAccountPassword -Identity $UsrDNPath -Reset -NewPassword (ConvertTo-SecureString -String $PWD -AsPlainText -Force)

           
