#!/bin/bash
all=false
file=""
list=""
proc=""
req=""
while [ -n "$1" ]
do
case "$1" in
-a) all=true;;
-f) file="$2"
shift ;;
-l) list+="$2 "
shift;;
--proc) proc="$2"
shift;;
--req) req="$2"
shift;;
*) echo "$1 is not an option";;
esac
shift
done

if [ -f "$file" ]
then
	while read -r line
	do
		list+="$line"
		list+=" "
	done < "$file"
fi

echo "$list"
