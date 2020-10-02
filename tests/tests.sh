#!/usr/bin/env bash 

# Variables to use in tests
readonly PASS=hejsan
readonly DOMAIN=example.com
readonly MD5HASH25=jrobuOPkc8l46F7kTxz0qgAA

passed=( ../sgp*.* ) # Path to scripts

# Test order, test descriptions
tests=( testUsage testExit testStdin dummy )
tmsgs=( "usage message" "exit status" "piped input" "dummy test" )
if type expect 2>&-; then
	tests=( expectTest ${tests[@]} )
	tmsgs=( "Expect user simulation" "${tmsgs[@]}" )
fi
runAll() {
	for i in ${!tests[*]}; do
		echo -e "$(($i+1))/${#tests[@]}\tTesting ${tmsgs[$i]}"
		scripts=("${passed[@]}") # Only test scripts who passed previous test
		passed=(  ); failed=(  )
		for file in ${scripts[*]}; do
			if ${tests[$i]}; then
				echo -e "\033[00;32mPASSED\033[00;00m:\t ${file##*/}"
				passed+=( "$file" )
				continue
			fi
			echo -e "\033[00;31mFAILED\033[00;00m:\t ${file##*/}"
			failed+=( "$file" )
		done
		pfmt="${#passed[@]}/${#scripts[@]}\tPassed\t ${passed[@]##*/}"
		ffmt="${#failed[@]}/${#scripts[@]}\tFailed\t ${failed[@]##*/}"
		echo -en "${pfmt//?/=}===\n ${pfmt}\n $ffmt\n${pfmt//?/-}---\n"
	done
}

## Tests that return true/false

testStdin() {
	echo "$PASS" | timeout 1 ./"$file" $DOMAIN 15 2>&1 | grep -qs "${MD5HASH25:0:15}"
}
testUsage() {
	./$file 2>&1 | grep -qs "^Usage"
}
testExit() {
	./$file > /dev/null 2>&1; test $? -eq 1
}
dummy() {
	true
}
expectTest() {
	./sim.exp "$file" $DOMAIN $PASS 25 $MD5HASH25 2>&-
}
# /

## Start testing
runAll
