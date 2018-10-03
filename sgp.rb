#!/usr/bin/ruby -w
require 'digest'
require 'io/console'
=begin This is my Ruby version of SuperGenPass 
	 hash password generation. 2018 by mnl@vandal.nu
	 Written as an excercise. Outputs to stdout
=end
unless ARGV[0] 
	puts "Usage #$0 [domainname] [length (optional)]\n"; exit 1;
end
domain = ARGV[0]
case ARGV[1].to_i # Password length
when 1..50
	len = ARGV[1].to_i
else
	len = 15 # Default pass length
end

def dig(h)
case ARGV[2]
when "sha512"
	return Digest::SHA512.base64digest h
when "md5",nil #md5 is default
	return Digest::MD5.base64digest h
else
	puts "Unknown digest: #{ARGV[2]}"; exit
end
end

print "Password: "
master = STDIN.noecho(&:gets).chomp
hash = master+":"+domain

def valid(h)
	#check if valid
	return false unless $i >= 10
	if ( h =~ /^[a-z]/ and h =~ /[A-Z]/ and h =~ /[0-9]/ )
		return true
	end
end

$i = 0
until valid(hash) do
	hash = dig(hash)
	hash = hash.tr('+/=','98A')
	$i += 1
end

#Done crop and print out
puts hash[0...len]
