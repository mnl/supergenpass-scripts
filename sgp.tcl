#!/usr/bin/env tclsh

# SuperGenPass password generator in TCL.
# Made by mnl@vandal.nu in 2019!

package require md5

if {$argc < 1} {
	puts stderr "Usage $argv0 domainname \[length] \[digest]"
	exit 1 ;# Quit
}
set domain [lindex $argv 0]
set len [expr {$argc > 1 ? [lindex $argv 1] : 15}] ;# Default length
set dig [expr {$argc > 2 ? [lindex $argv 2] : "md5"}] ;# Digest 
switch $dig {
	"sha512" {
		set dig "sha"
	}
	"md5" {
		set dig "md5"	
	}
	default {
		puts stderr "Unsupported digest: $dig"
		exit 1
	}
}
#set pass "hejsan"
exec stty -echo ;# Hide input (unix only)
puts -nonewline "Password: "
flush stdout
gets stdin pass
exec stty echo ;# turn on echo again
exec tput cr >@stdout <@stdin ;# move cursor to the left
set hash "$pass:$domain"
proc makeHash {hash} {
	set hash [binary encode base64 [md5::md5 $hash]]
	return [string map { + 9 / 8 = A } $hash]
}
set hash [makeHash $hash]
puts [string range $hash 0 $len] ;# Cut to length and print
