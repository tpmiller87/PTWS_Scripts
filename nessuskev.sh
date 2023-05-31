#!/bin/bash

#Download the Nessus KEV catalog as a csv
wget https://www.cisa.gov/sites/default/files/csv/known_exploited_vulnerabilities.csv -q -O kev_catalog.csv
kev_cat=kev_catalog.csv

#Take the Nessus scan from the mission and pull out the CVEs
mission_cves=$(cat $1 | grep '"CVE-*' | cut -d ',' -f2 | sort -u )

ctime=$(while read line;
do
   final=$(grep $line $kev_cat | cut -d ',' -f 1 )
   while read cve;
   do
      grep $cve $1 | cut -d ',' -f 2
   done <<< $final
done <<< $mission_cves | uniq -c | sort -nr | awk -F ' ' '{print $2,": ",$1","}' | sed 's/ :  /: /g' | awk '{print}' ORS=' ')

echo $ctime | tr -d '\n' | sed 's/,$//'

#delete the KEV catalog
rm $kev_cat
