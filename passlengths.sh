#!/bin/bash

Help () {
	echo "Usage: ./passlengths.sh <<file with plaintext passwords>>"$'\n'
	echo "-Spits out the amount of passwords that contain [x] amount of characters"
	echo "-Currently ranges from one character to 20 characters (to match PTWS)"
	echo "-Also creates the string used in PTWS for the \"PasswordLengths\" metric in the password statistics finding"
}

if [[ $1 == '' ]]; then
	echo "Please supply a file with plaintext passwords or use -h for help"
	exit
elif [[ $1 == '-h' ]]; then
	Help
	exit
fi

#total number of lines (passwords) in the input file.
total_passes=$(sed '/^$/d' $1 | wc -l)

echo $'\n' $total_passes "total passwords loaded."$'\n'

#adding a newline at the beginning of the file and saving it to another temp file. Randomized as to not
#delete a different file on the system.
sed '/^$/d' $1 > e984a57019dca4d99c605d3fb.txt
sed -i '1s/^/\n/' e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	onechar=$(grep "^.\{1\}$" | wc -l)
	echo $onechar "passwords that are only one character."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	twochar=$(grep "^.\{2\}$" | wc -l)
	echo $twochar "passwords that are two characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	threechar=$(grep "^.\{3\}$" | wc -l)
	echo $threechar "passwords that are three characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	fourchar=$(grep "^.\{4\}$" | wc -l)
	echo $fourchar "passwords that are four characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	fivechar=$(grep "^.\{5\}$" | wc -l)
	echo $fivechar "passwords that are five characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	sixchar=$(grep "^.\{6\}$" | wc -l)
	echo $sixchar "passwords that are six characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	sevenchar=$(grep "^.\{7\}$" | wc -l)
	echo $sevenchar "passwords that are seven characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	eightchar=$(grep "^.\{8\}$" | wc -l)
	echo $eightchar "passwords that are eight characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	ninechar=$(grep "^.\{9\}$" | wc -l)
	echo $ninechar "passwords that are nine characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	tenchar=$(grep "^.\{10\}$" | wc -l)
	echo $tenchar "passwords that are ten characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	elevenchar=$(grep "^.\{11\}$" | wc -l)
	echo $elevenchar "passwords that are eleven characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	twelvechar=$(grep "^.\{12\}$" | wc -l)
	echo $twelvechar "passwords that are twelve characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	thirteenchar=$(grep "^.\{13\}$" | wc -l)
	echo $thirteenchar "passwords that are thirteen characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	fourteenchar=$(grep "^.\{14\}$" | wc -l)
	echo $fourteenchar "passwords that are fourteen characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	fifteenchar=$(grep "^.\{15\}$" | wc -l)
	echo $fifteenchar "passwords that are fifteen characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	sixteenchar=$(grep "^.\{16\}$" | wc -l)
	echo $sixteenchar "passwords that are sixteen characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	seventeenchar=$(grep "^.\{17\}$" | wc -l)
	echo $seventeenchar "passwords that are seventeen characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	eighteenchar=$(grep "^.\{18\}$" | wc -l)
	echo $eighteenchar "passwords that are eighteen characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	nineteenchar=$(grep "^.\{19\}$" | wc -l)
	echo $nineteenchar "passwords that are nineteen characters."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	twentychar=$(grep "^.\{20\}$" | wc -l)
	echo $twentychar "passwords that are twenty characters."
done < e984a57019dca4d99c605d3fb.txt

#removing the temp file
rm e984a57019dca4d99c605d3fb.txt

echo $'\n'"Copy and paste this into PTWS for the CTIME password statistics value:" $'\n'

echo \"PasswordLengths\":[{\"Length1\":$onechar,\"Length2\":$twochar,\"Length3\":$threechar,\"Length4\":$fourchar,\"Length5\":$fivechar,\"Length6\":$sixchar,\"Length7\":$sevenchar,\"Length8\":$eightchar,\"Length9\":$ninechar,\"Length10\":$tenchar,\"Length11\":$elevenchar,\"Length12\":$twelvechar,\"Length13\":$thirteenchar,\"Length14\":$fourteenchar,\"Length15\":$fifteenchar,\"Length16\":$sixteenchar,\"Length17\":$seventeenchar,\"Length18\":$eighteenchar,\"Length19\":$nineteenchar,\"Length20\":$twentychar\}\]\}
