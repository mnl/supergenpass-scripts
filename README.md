# SuperGenPass Script Repo :octocat:
This is a collection of experimental scripts implementing the SuperGenPass algorithm in various scripting languages. All scripts are written by me. I write them to learn new languages so they vary in quality and efficenty.

I aim for them to be:
- Small and efficient
- Standalone or using standard libs

Most can use MD5 och SHA512 digests. Accepts arguments domain (or url) length and digest. Outputs to stdout.

## Node JavaScript `sgp-node.js`
JavaScript or ECMAScript 6. Reading stdin is far from a oneliner in Node. Doesn't hide input but overwrites it. 

## R `sgp.R`
Use with Rscript hashbang or interactively in REPL/IDE. Make sure to `package.install("openssl")` first

## Elixir `sgp.exs`
Run with iex or elixir. Seems to do the job but no idea how useful or correct it is.
Uses standard libraries. Hidden input, domain validation or other digests are not implemented.

## Lua 5.3 `sgp.lua`
Lua version. Depends on `hashings` library and lua binary operators

## PHP 5? `sgp.php`
Tried to use as many built in functions as possible :)
Doesn't quite hide password. Not sure if that part is Windows compatible...

## Perl `sgp.pl`
Uses a big fat regexp since it's Perl

## PowerShell `sgp.ps1`
Windows scripting is weird. This one both checks the url and handles the clipboard.

## Python 3 `sgp.py`
Strips url to domain.tld. Effort made to not use regexp.

## Ruby `sgp.rb`
I hope all ruby installs come with the digest gem

## Bash4 `sgp.sh`
Uses openssl for hashing. Doesn't use tr and sed like other command line sgp scripts do.

## Zenity + bash `sgpclip`
Takes url from clipboard, strips out first level domain, hashes with master password and puts new password hash in clipboard.
Zenity for dialog box, shell and openssl for everything else.
