#!/usr/bin/env -S Rscript --vanilla

# SuperGenPass in R. Made by mnl@vandal.nu 2018
# Make sure to: package.install("openssl")

library("openssl")

# Get and handle arguments
args <- commandArgs(trailingOnly=TRUE)
if (length(args)==0) { stop("Usage ./sgp.R domainname [length] [digest]") }
domain <- args[1]
dig = switch ( args[2],	
							sha256 = {sha256}, 
							sha512 = {sha512}, 
							{md5} ) # Default digest and for unknown entries
len <- ifelse(length(args) > 2,args[3],15) # Default hash length

# Get secure input from R
if (interactive()) { pass <- askpass("Password: ") 
# Rscript is considered non-interactive so a workaround is needed:
} else { cat("Password: "); pass <- readLines("stdin",n=1);} 

hash <- paste(pass,domain,sep=':')

reapply <- function(hash){
	# Do hashing and translate to alphanumerical characters
	hash <- base64_encode(dig(charToRaw(hash)))
	hash <- chartr('+/=','98A',hash)
	return(hash)
}
valid <- function(hash){
	# Check hash for starting lowercase, digits and uppercase
	if ((substring(hash,0,1) %in% letters) &&
			(!identical(hash,tolower(hash))) &&
			(grepl('[0-9]',hash)))
	{
		return(TRUE)
	}
	return(FALSE)
} # Loop 10 times and the until hash is valid SGP Pass
for (i in 1:1000) {
	hash <- reapply(hash)
	if (i <= 10) { next }
	if (valid(hash)) { break }
}
# Done! Cut to length and print
hash = substring(hash,0,min(len,nchar(hash)))
cat(paste(hash,"\n"))
