# SuperGenPass Script Repo :octocat:
This is a collection of experimental scripts implementing the SuperGenPass algorithm in various scripting languages. All scripts are written by me. I write them to learn new languages so they vary in quality and efficenty.

I aim for them to be:
- Small and efficient
- Standalone or using standard libs

Most can use MD5 och SHA512 digests. Accepts arguments domain (or url) length and digest. Outputs to stdout.

## Elixir `sgp.exs`
Run with iex or elixir. Seems to do the job but no idea how useful or correct it is.
Uses standard libraries. Hidden input, domain validation or other digests are not implemented.

## Julia `sgp.jl`
Tested with Julia 1.0.2. Base64 and SHA are in stdlib, `Pkg.add("MD5")` for MD5. Hides input with getpass, also in stdlib. Not very fast at all but I don't think that's Julia's fault.

## Node JavaScript `sgp-node.js`
JavaScript or ECMAScript 6. Reading stdin is far from a oneliner in Node. Doesn't hide input but overwrites it. 

## Lua 5.3 `sgp.lua`
Lua version. Depends on `hashings` library and lua binary operators

## PHP 5? `sgp.php`
Tried to use as many built in functions as possible :)
Doesn't quite hide password. Not sure if that part is Windows compatible...

## Perl `sgp.pl`
Uses a big fat regexp since it's Perl

## PowerShell `sgp.ps1`
Simplified and more compatible cli version. The old version that does more stuff is now called sgpclip.ps1

## Python 3 `sgp.py`
Strips url to domain.tld. Effort made to not use regexp.

## R `sgp.R`
Use with Rscript hashbang or interactively in REPL/IDE. Make sure to `package.install("openssl")` first

## Ruby `sgp.rb`
I hope all ruby installs come with the digest gem

## Bash4 `sgp.sh`
Uses openssl for hashing. Doesn't use tr and sed like other command line sgp scripts do.

## TCL `sgp.tcl`
Tested on TCL 8.6. Depends on tcllib's md5. As of now sha512 or other digests are not supported.

## Zenity + bash `sgpclip`
Takes url from clipboard, strips out first level domain, hashes with master password and puts new password hash in clipboard.
Zenity for dialog box, shell and openssl for everything else.

## PowerShell clipboard `sgpclip.ps1`
This one both checks the url and handles the clipboard. These features were moved out from the first powershell variant.

Tests are written in `Expect` and `Bash4`. Not all behave quite as they should regarding error messages and such.
