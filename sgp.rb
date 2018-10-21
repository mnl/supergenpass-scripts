#!/usr/bin/ruby -w
require 'digest'
require 'io/console'
=begin This is my Ruby version of SuperGenPass 
	 hash password generation. 2018 by mnl@vandal.nu
	 Written as an excercise. Outputs to stdout
=end
domain, len, $dig = ARGV

unless domain
	puts "Usage #$0 [domainname] [length (optional)]\n"; exit 1;
end
#Set password length to 15 is not user defined
len = (len.to_i.equal? 0) ? 15 : len.to_i

case $dig
  when "md5",nil then $dig = Digest::MD5 #md5 is default
  when "sha512" then $dig = Digest::SHA512
  else
	  puts "Unknown digest: #{$dig}"; exit 1
end

print "Password: "
master = STDIN.noecho(&:gets).chomp
hash = master+":"+domain

def valid(h)
	# Has to start with lowercase and contain uppercase and numbers
	if ( h =~ /^[a-z]/ and h =~ /[A-Z]/ and h =~ /[0-9]/ )
		return true
	end
end

10.times do |count|
	hash = $dig.base64digest(hash)
	hash.tr!('+/=','98A')
	next if count < 9 # Hash ten times and then until valid
	redo unless valid(hash)
end

#Done crop and print out
puts hash[0...len]
