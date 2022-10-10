#!/bin/bash

#***************************************************************************************#
# Author: 	Baris Caglar
# Purpose:	This script accepts a text file containing a list of domain names
# 			and uses the nslookup command to determine whether each domain is active
# 			and saves the results to a new file
# Version: 	1.0
# License: GPL version 2.0 or above
#***************************************************************************************#



# Usage: lookup <file>

# Clear screen
clear

# Display the banner and Usage
echo -e "
  _                       _                
 | |                     | |               
 | |     ___   ___   ___ | | ___   _ _ __  
 | |    / _ \ / _ \ / _ \| |/ / | | | '_ \ 
 | |___| (_) | (_) | (_) |   <| |_| | |_) |
 |______\___/ \___/ \___/|_|\_\\__,_| .__/ 
                        version 1.0 | |    
                                    |_|    

\033[1;33mUsage:\033[0m loookup sitelist.txt or sitelist

"

# Read user input
read -p "Enter FILENAME: " input

# Declare variables
FILENAME=${input%.*}
SAVEAS=$FILENAME"_ACTIVE"

# Ensure a filename was input
if [ -z "$input" ]
then
	echo -e "\n Usage: lookup <filename=txt>\n "
	exit 1
fi

# Ensure the target file does work without extension
if [[ ! $input == *.txt ]]
then
	input=$input.txt
fi

# Ensure target file is exists
if [ ! -f "$input" ]
then
	echo -e "[-] $input does not exist \n"
	exit 1
fi
# If files already exists, delete to rerun scan
rm -f $SAVEAS

echo ""
# Initialize the counter
n=1
# read the text file
	while read url; do
			for domain in $url
			do
				echo -e "[+] $n checking $domain \033[1;33m\xE2\x9C\x94\033[0m"
				nslookup $domain | grep -qi "Name" && echo -e "$domain" >> $SAVEAS
				# Increment the value of n by 1
				(( n++ ))
			done
	done < ${input}

# Display total scan result
echo -e "\nScanned Total :($((n-1))) assets" 

# Show final result in notepad
while true; do
		echo ""
        read -p "Do you want to view the output now? (y/n) " yn 
        case $yn in
                [Yy]* ) open ${SAVEAS}; break;;
                [Nn]* ) break;;
        esac
done
echo -e "\nExiting now!\n"
exit 1
