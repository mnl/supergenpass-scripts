<#
    SuperGenPass implementation in PowerShell. 
    Put an URL in clipboard and it will be replaced with a SGP hash
    Falls back to command line input and behaves like the others
    Version 0.2 made in 2018 by mnl@vandal.nu (and barely works.)
#>

$url = Get-Clipboard # Get domain from clipboard
$domain = ForEach ($fragment In ($url -split "\/")) {
    if ($fragment -imatch "\w{1,}\.\w{2,}$") { # Look for a domain name
        ($fragment.Split('.')[-2]+'.'+$fragment.Split('.')[-1]).ToLower()
    }
}
if ($domain -and -not $args[0]) { 
    $args = $domain,15,"md5" # The clipboard version uses default values.
    $clip = "yes"
}
else { # Fallback to command line
$0 = ($PSCommandPath -split "\\")[-1]
    if ($args.Count -lt 1) {
        echo "Usage: $0 [domainname] [length (optional)] digest (optional)"
        exit
    }
    $domain = $args[0]
}
if ($args[1] -notin 1..900) { $len = 15 } # Set default length
else { $len = $args[1] }

if ($args[2] -inotin "sha512" ) { # Set default digest 
    $dig = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider 
} 
else { 
    $dig = new-object -TypeName System.Security.Cryptography.SHA512CryptoServiceProvider 
}

# Get input, AsSecureString hides input
$master = Read-Host "Password" -AsSecureString
# Make weird string normal again
$master = (New-Object PSCredential "user",$master).GetNetworkCredential().Password

$hash = "${master}:${domain}"

function valid($hash) { 
	$hash -cmatch '^[a-z].*[A-Z]' -and $hash -match '[0-9]' -and $i -ge 10 
}
$i=0
do {
    $buffer = new-object -TypeName System.Text.UTF8Encoding # Do hashing via buffer
    $hash = [Convert]::ToBase64String($dig.ComputeHash($buffer.GetBytes($hash)))
    # Replace chars to conform to SGP alphabet
    $hash = $hash -creplace "\+", "9" -creplace "\/", "8" -creplace "=", "A"
    $i++
} until (valid $hash)

# Cut to length if there are enough characters
$hash = $hash.Substring(0,($hash.Length,$len |Measure -Minimum).Minimum)
if ($clip) { 
    Set-Clipboard -Value $hash 
    Write-Host "Success: Password for $domain saved on clipboard."
    Write-Warning -Message "Don't forget to clear it!"
    Start-Sleep -m 1500 # Sleep so we can read 
}
else { echo $hash }
