#!/usr/bin/env perl
=begin comment
Perl SuperGenPass implementation. By mnl@vandal.nu 2018
Currently without url stripping. Prompt hiding only 
works on *nix with stty
=cut
use strict;
use warnings;
use Digest::SHA qw(sha512_base64);
use Digest::MD5 qw(md5_base64);
 
if ($#ARGV < 0) {
	print "Usage $0 [domainname] [length (optional)]\n"; exit 1;
}
system('/usr/bin/stty', '-echo');  # Disable echoing
print "Password: "; 
chomp(my $master = <STDIN>); 
system('/usr/bin/stty', 'echo');   # Turn it back on
my $len = $ARGV[1] ? $ARGV[1] : 15;
my $dig = $ARGV[2] ? $ARGV[2] : "md5";
my $hash ="$master:$ARGV[0]";
my $i = 1;

sub valid {
#SuperGenPass hashes should be hashed at least 10 times and until
# they start with [a-z], contain [A-Z] and [0-9]
	return (($i > 10 ) and $hash =~ m/^[a-z](?=.*\d)(?=.*[A-Z])/ ) 
}

until (valid) {
	if ($dig eq "sha512") {
		$hash = sha512_base64($hash); 	}
	elsif ($dig eq "md5" ) { 
		$hash = md5_base64($hash); }
	else { print "\nUnknown digest: $dig\n"; exit 1 }

	while (length($hash) % 4) {
		$hash .= 'A'; #perl's Digest doesn't add padding
	}
	$hash =~ tr!+/!98!; #SGP requires these chars translated
	$i++;
}

$hash =~ s/.{$len}\K.*//s; #Cut to max length
print "$hash\n";
