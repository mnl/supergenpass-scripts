#!/usr/bin/pwsh
<#
	Supergenpass implementation in PowerShell Core 6
	Tested on Debian 9 and Windows 10 
	Version 0.1. See sgp.ps1 for advanced cliboard version
	Made by mnl@vandal.nu in 2019!
#>
# Set parameters PowerShell-style
Param(
	[String[]]$domain,
	[int]$len,
	[String[]]$dig
		)
# Get script name ($0) and strip path (win and unix paths)
$0 = ($PSCommandPath -split "[\\/]")[-1]
# Display error message to comply with tests. No mandatory param flag here.
if (!$domain) { 
	Write-Host -Message "Usage: $0 [domainname] length digest"
	exit 1
}
if (!$len) { $len = 15 } # Set default length
if ($dig -notin "sha512") {
	# Set default digest
	$digest = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
} else {
	$digest = new-object -TypeName System.Security.Cryptography.SHA512CryptoServiceProvider
}
# Get input, AsSecureString hides input
$master = Read-Host "Password" -AsSecureString

# Make string normal again and concat with domain
$hash = (New-Object PSCredential "user",$master).GetNetworkCredential().Password+":${domain}"

function valid([String]$hash) {
	return $i -ge 10 -and $hash -cmatch '^[a-z].*[A-Z]' -and $hash -match '[0-9]'
}
# Prepare iterator and buffer
$i = 0
$b = New-Object -TypeName System.Text.UTF8Encoding 
do {
	$hash = [Convert]::ToBase64String($digest.ComputeHash($b.GetBytes($hash)))
	# Replace +/= accoring to SGP specs
	$hash = $hash -creplace "\+", "9" -creplace "\/", "8" -creplace "=", "A"
	$i++
} until (valid $hash)

# Cut to length if there are enough characters
$hash = $hash.Substring(0,($hash.Length,$len | Measure -Minimum).Minimum)
Write-Host $hash
