#!/bin/bash
#apt install bc
all=false 
file="" 
list=""
proc=""
req=""
while [ -n "$1" ]
do
case "$1" in
-a) all=true;; # Delete all
-f) file="$2" #Get source from a file
shift ;;
-l) list+="$2 " #Get source from a list
shift;;
--req) req="$2" #Required amount of memory
shift;;
*) echo "$1 is not an option";;
esac
shift
done

mul=$(echo "$req" | sed 's/[^a-zA-Z]*//g') #Getting symbolic multiplyer
req=$(echo "$req" | sed 's/[^0-9.]*//g') #Getting numeric value of required amount
case "$mul" in
k) req=$(echo "$req*1000" | bc)
   req=$(echo "($req+0.5)/1" | bc);;
M) req=$(echo "$req*1000000" | bc)
   req=$(echo "($req+0.5)/1" | bc);;
G) req=$(echo "$req*1000000000" | bc)
   req=$(echo "($req+0.5)/1" | bc);;
*) req=$(echo "($req+0.5)/1" | bc);;
esac

echo "$req"

if [ -f "$file" ]
then
	while read -r line
	do
		list+="$line"
		list+=" "
	done < "$file"
fi

echo "$list"
