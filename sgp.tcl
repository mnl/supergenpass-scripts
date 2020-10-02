#!/usr/bin/env tclsh
#
# SuperGenPass password generator in TCL.
# Made by mnl@vandal.nu in 2019!

if {$argc < 1} {
	puts stderr "Usage $argv0 domainname \[length]"
	exit 1 ;# Quit
}
set domain [lindex $argv 0]
set len [expr {$argc > 1 ? [lindex $argv 1] : 15}] ;# Default length
proc dig {arg} {md5::md5 $arg} ;# Only MD5 support right now :(

exec stty -echo ;# Hide input (unix only)
puts -nonewline "Password: "
flush stdout
gets stdin pass
exec stty echo ;# turn on echo again
exec tput cr >@stdout <@stdin ;# move cursor to the left

proc valid {hash} {
# Hash should begin with lowercase and contain numbers and uppercase
	if {
		[string match {[A-Z0-9]*} $hash] ||
		[string is alpha $hash] ||
		! [string match {*[A-Z]*} $hash]
	} {return 0}
	return 1 ;# String is valid
}

proc rehash {hash times} {
	if { $times < 0 && [valid $hash] } { return $hash }
	set hash [string map { + 9 / 8 = A } [binary encode base64 [dig $hash]]]
	return [rehash $hash [expr $times - 1]]
}
set hash [rehash "$pass:$domain" 10] ;# hash ten times
set max [expr {$len > [string length $hash] ? [string length $hash] : $len}]
puts [string range $hash 0 $max] ;# Cut to length and print
