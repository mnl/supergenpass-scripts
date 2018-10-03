# SuperGenPass Script Repo
This is a collection of experimental scripts implementing the SuperGenPass algorithm in various scripting languages. All scripts are written by me. I write them to learn new languages so they vary in quality and efficenty.

I aim for them to be:
- Small and efficient
- Standalone or using standard libs

Most can use MD5 och SHA512 digests. Accepts arguments domain (or url) length and digest. Outputs to stdout.

## Ruby `sgp.rb`
I hope all ruby installs come with the digest gem

## Bash4 `sgp.sh`
Uses openssl for hashing. Doesn't use tr and sed like other command line sgp scripts do.

## Bash4 `sgp22.sh
Same as above but strips domain to first level and top domain. Broken for tdl's like `co.uk` etc.

## Python `sgp10.py`
Strips url to domain.tld. Effort made to not use regexp.

## Perl `sgp02.pl`
Uses a big fat regexp since it's Perl

## Zenity + bash `sgpclip`
Takes url from clipboard, strips out first level domain, hashes with master password and puts new password hash in clipboard.
Zenity for dialog box, shell and openssl for everything else.
