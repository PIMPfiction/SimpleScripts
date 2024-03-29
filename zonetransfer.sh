#Author: Goktug Cetin
#ShellScript (bash)

#!/bin/bash

path=$(pwd)
echo -e "Domain for zone transfer"
read domain


dig NS $domain | grep $domain. | awk -F" " '{ print $5 }' >> firstdomains

#part2(zone transfer section)

cat $pwd/firstdomains | while read output 

do dig @"$output" $domain axfr>> zoneoutput
done

#part3(getting all sbudomains)
onlydomain=$(echo $domain | awk -F"." {'print $1 '})

cat zoneoutput | grep ".$domain" | awk -F" " '{print $1}' | grep $onlydomain | sort -u | uniq | grep -v "_" >> allsubs.txt

echo "You can interrupt the script, if you dont want to scan them."

#part4(get ip for host)

cat allsubs.txt | while read subdom

do ping -c 1 "$subdom" | awk  '/PING/{print $3 }' >> IPlist

done

#part5(nmap Tcp Udp scan)

cut -f 2 -d "(" IPlist | cut -f 1 -d ")" | sort -u | uniq >> NmapScan

echo "You need to be Root for UDP scan " 

cat NmapScan| while read nmapscan

do sudo nmap -sT "$nmapscan" >> NmapReport | sudo nmap -sU "$nmapscan" >> NmapReport 

done


