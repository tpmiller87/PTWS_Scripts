#!/bin/bash

Help () {
	echo "Usage: ./nessuskev.sh <<CSV Nessus report>>"$'\n'
	echo "-Identifies all of the CVEs listed in the Nessus report"
	echo "-Formats the output into the format used in the \"Nessus KEV catalog\" PTWS finding"
	echo "-It's just a bash one liner but I didn't want to forget how to do it :)"
}

if [[ $1 == '' ]]; then
	echo "Please supply the Nessus report in CSV format or use -h for help"
	exit
elif [[ $1 == '-h' ]]; then
	Help
	exit
fi

cat $1 | grep -E '"CVE-*' | cut -d ',' -f2 | uniq -c | sort -u | awk -F ' ' '{print $2,": ",$1","}' | sed 's/" :/":/g' | sed 's/: /:/g' | awk '{print}' ORS=' ' | sed 's/, "/,"/g'
