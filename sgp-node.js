#!/usr/bin/env node
// Node JS version of SuperGenPass
// ECMAScript 5? Requires crypto and readline
// Version 1.0 by mnl@vandal.nu in 2018

const crypto = require('crypto');
const readline = require('readline');
// Set arguments and defaults
const [node, script, domain, len = 15, dig = 'md5'] = process.argv
// Check for errors in arguments
if (isNaN(len) || domain == null || !crypto.getHashes().includes(dig)) {
	console.error("Usage: "+script+
		" [domainname] [length (optional)] [digest (optional)]");
	process.exit(1);
}
// Check for upper case, lower case start digits
function valid(h) {
	if (h != h.toLowerCase() &&	/^[a-z].*\d/.test(h)) { return true; }
	return false;
}
// Getting input in surpisingly complicated with Node
rl = readline.createInterface({	input: process.stdin,	output: process.stdout });
rl.question('Password: ', (pass) => {
	// Write over the user input instead of turning off echo
	readline.moveCursor(process.stdin,10,-1);

	var hasher = crypto.createHash(dig);
	var hash = pass+":"+domain;
	var i = 10; // Hash at least 10 times
	const tr = {'+':'9','/':'8','=':'A'}; // Translate these chars in hash 
	do { // Hash multiple times until hash is ok
		hasher = crypto.createHash(dig).update(hash);
		hash = hasher.digest('base64').replace(/[+\/=]/g, c => tr[c]);
		i--;
	} while( i > 0 || !valid(hash) )
	// Done! Cut to length and print
	console.log(hash.substring(0,len));
	rl.close();
});
