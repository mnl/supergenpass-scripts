#!/bin/env python3
"""
Generate a SuperGenPass hash to stdout
version 1.0 by mnl@vandal.nu 2018
~~~~~~~~~~~~~~~~~~~~~~~
"""
from hashlib import md5, sha512
from base64 import b64decode, b64encode
from sys import argv
# to supress echo
from getpass import getpass as input

# Pad argv
while len(argv)<4:
    argv.append(False)

# Set defaults
url = argv[1]
length = 15 if not argv[2] else int(argv[2])
dig = sha512 if argv[3] == "sha512" else md5

if not url or not 1 + url.find('.'):
    usage="Usage: {0} [domainname] [length (optional)] [digest (optional)]"
    print(usage.format(argv[0]))
    raise SystemExit(1)

master = input("Password: ")

# Strip url to first level domain + tld
domain = url.split('.')[-2].split('/')[-1]\
+'.'+url.split('.')[-1].rsplit('/')[0]

hash = (master+":"+domain).encode() #Bytestring

ALNUM = set('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')
def valid(h):
    """Return bool if h is a valid SuperGenPass hash"""
    h = bytes.decode(h)
    if h[0].islower():
        if set(h).issubset(ALNUM):
                # Yes! Digits, Upper- and lowercase are present
                return True
    return False

"""
Password should be hashed at least 10 times until it begins with
lowercase and contains both uppercase and number characters.
"""

i=0
while i<10:
    hash = dig(hash) # Bytesting
    hash = b64encode(hash.digest(),b'98').replace(b'=',b'A') # Bytestring
    if i<9 or (i==9 and valid(hash)):
        i+=1

# Done: Crop to length and print
print(bytes.decode(hash)[:length])
