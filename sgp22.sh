#!/bin/bash
# Generates a SuperGenPass hash to stdout
# Needs bash4 and openssl
if [ $# -lt 1 ]; then
	echo "Usage: $0 [domainname] [length (optional)] [digest (optional)]"; exit 1
fi
read -srp 'Password: ' master
readonly domain=${1,,}
readonly length=${2:-10}
readonly digest=${3:-md5}
declare hash=$master:$domain
let i=0
validHash() {
	# Password should be hashed at least 10 times until it begins with 
	# lowercase and contains both uppercase and number characters.
	[[ $i -ge 10 ]] &&
	[[ "$hash" =~ (^[a-z].*) ]] && 
	[[ "$hash" =~ ([A-Z]) ]] &&
	[[ "$hash" =~ ([0-9]) ]]
}
until validHash
do
	let "i++"
	hash=$(echo -n "$hash" | openssl ${digest} -binary | openssl base64)
	hash=${hash//+/9}; hash=${hash//\//8}; hash=${hash//=/A} # tr +/= 98A
done
echo ${hash:0:length}
