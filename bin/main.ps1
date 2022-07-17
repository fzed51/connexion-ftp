<#
.SYNOPSIS
    Envoie le dossier local sur un serveur ftp
.DESCRIPTION
    Envoie le dossier local sur un serveur ftp
#>

[CmdletBinding()]
param (
    [string] $SrvSftp,
    [string] $User,
    [string] $Source = ".",
    [string] $Destination = ""
)

Get-Command psftp.exe -ErrorAction Stop | Out-Null

$Tmp = New-TemporaryFile
$Files = Get-ChildItem -Recurse -Name -File $Source
$pass = Read-Host -AsSecureString

$Files | ForEach-Object {
    ("put $_ {0}$_" -f $Destination) | Add-Content $Tmp
}

psftp.exe -pw $pass -b $Tmp.FullName ("{0}@{1}" -f $User, $SrvSftp)

Remove-Item $Tmp