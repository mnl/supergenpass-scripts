#!/usr/bin/env tclsh
#
# SuperGenPass password generator in TCL.
# Made by mnl@vandal.nu in 2019!

if {$argc < 1} {
	puts stderr "Usage $argv0 domainname \[length] \[digest]"
	exit 1 ;# Quit
}
set domain [lindex $argv 0]
set len [expr {$argc > 1 ? [lindex $argv 1]} : 15] ;# Default length
#set pass "hejsan"
exec stty -echo ;# Hide input (unix only)
puts -nonewline "Password: "
flush stdout
gets stdin pass
exec stty echo ;# turn on echo again
puts $hash
