# SuperGenPass Script Repo :octocat:
This is a collection of experimental scripts implementing the SuperGenPass algorithm in various scripting languages. All scripts are written by me. I write them to learn new languages so they vary in quality and efficenty.

I aim for them to be:
- Small and efficient
- Standalone or using standard libs

Most can use MD5 och SHA512 digests. Accepts arguments domain (or url) length and digest. Outputs to stdout.

## Ruby `sgp.rb`
I hope all ruby installs come with the digest gem

## Bash4 `sgp22.sh`
Uses openssl for hashing. Doesn't use tr and sed like other command line sgp scripts do.

## Python `sgp10.py`
Strips url to domain.tld. Effort made to not use regexp.

## Perl `sgp02.pl`
Uses a big fat regexp since it's Perl

## Lua 5.3
Lua version. Depends on `hashings` library and lua binary operators

## PHP 5?
Tried to use as many built in functions as possible :)
Doesn't quite hide password. Not sure if that part is Windows compatible...

## Zenity + bash `sgpclip`
Takes url from clipboard, strips out first level domain, hashes with master password and puts new password hash in clipboard.
Zenity for dialog box, shell and openssl for everything else.
