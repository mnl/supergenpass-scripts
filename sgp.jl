#!/usr/bin/env julia
#=
SuperGenPass version in Julia. Made in 2018 by mnl@vandal.nu
Base64 and SHA are in stdlib. MD5 or Nettle needs to be Pkg.add:ed
=#

using MD5, Base64 #Pkg.add("MD5") 

len = 15 # Set defaults
dig = md5
if (length(ARGS) < 1) # Get argv
	print(stderr, "Usage "*PROGRAM_FILE*" [domainname] [length, digest (optional)]\n")
  exit(1)
elseif (length(ARGS) > 1)
	len = tryparse(Int, ARGS[2])
	if (length(ARGS) > 2)
		if (occursin("sha",ARGS[3]))
			using SHA
			dig = sha256
		end
	end
end

# Get input
pass = Base.getpass("Password")
hash = read(pass,String) * ":" * ARGS[1]
Base.shred!(pass)

translate(c) = get(Dict('+' => '9', '/' => '8', '=' => 'A'),c,c) # poor mans tr!

function sgp!(h)
	return map(translate, base64encode(dig(h)))
end
function sgp!(n::Int) # Multiple dispatch, yeah
	if (n>1)
		global hash = sgp!(hash)
		return sgp!(n-1)
	end
	return sgp!(hash)
end

function valid(hash) 
	if (islowercase(hash[1]) && # Testing out native Julia functions instead of regex
			findfirst(isuppercase, hash) != nothing && 
			findfirst(isdigit, hash) != nothing)
      return true
	end
  return false
end

hash = sgp!(10)
while(!valid(hash))
	global hash = sgp!(hash)
end

println(hash[1:min(len,end)]) # Print and cut to lenght 
