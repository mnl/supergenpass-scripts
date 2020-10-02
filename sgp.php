#!/usr/bin/env php
<?php
/* PHP SuperGenPass implementation. Made by mnl@vandal.nu in 2018.
 * Notice: This is a command line script, it's not meant for the web.
*/
if (PHP_SAPI !== 'cli') { die("Not running from command line"); };

if ($argc < 2) {
	fwrite(STDERR, "Usage $argv[0] [domainname] [length (optional)]\n"); die(1);
}
$domain = $argv[1]; # Strip input url to first level + tld
if (strpos($argv[1],'/') === FALSE ) { $domain = "//".$domain; }
# parse_url fails to get 'host' without at least one / for scheme
$domain = explode('.',parse_url($domain)['host']);
$domain = implode('.',array_slice($domain,-2,2));

$len = (isset($argv[2]) ? $argv[2] : 15); # Set default length
if (!isset($argv[3])) { $dig = "md5"; } # Set default digest
elseif (in_array($argv[3], hash_algos())) { $dig = $argv[3]; }
else { die("Unknown digest: $argv[3]\n"); }

print("Password: \033[30;40m"); # Not quite hiding black on black...
$master = stream_get_line(STDIN, 80, PHP_EOL); #Works on Windows too?
print("\033[0m"); # Restore
$hash = $master.":".$domain;

function valid($h,$i) {
	if ( $i>10 and ctype_lower($h{0}) and # ^[a-z]  Try out three different 
		preg_match("/[[:upper:]]/",$h) and  #  [A-Z]  php functions to match
		(bool)strpbrk($h, "0123456789")) {  #  [0-9]  chars because why not?
		return true; 
	}
	else { return false; };
}
$i=1; #Loop
do {
	$hash = base64_encode(hash($dig, $hash, TRUE));
	$hash = strtr($hash, "+/=", "98A"); # these chars are translated in SGP
	$i++;
} while(!valid($hash,$i));

# Done! Cut to length and print
$hash = substr($hash, 0, $len);
print($hash.PHP_EOL)
?>
