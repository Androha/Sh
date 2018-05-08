#!/bin/bash
#apt install bc
all=false
file=""
list=""
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

if [ "$req" != "" ]
then
  case "$mul" in
    M) req=$(echo "$req*1000" | bc)
       req=$(echo "($req+0.5)/1" | bc);;
    G) req=$(echo "$req*1000000" | bc)
       req=$(echo "($req+0.5)/1" | bc);;
    *) req=$(echo "($req+0.5)/1" | bc);;
  esac

  if [ -f "$file" ]
  then
    while read -r line
    do
      list+="$line"
      list+=" "
    done < "$file"
  fi

  if [ "$list" != "" ]
  then
    for prc in $list
    do
      #Workfield
      echo "$prc"
    done
  else
    echo "You must enter at least one process to be killed.
It can be done via -f or -l options."
    exit 2
  fi

else
  echo "You must enter a valid requirement option with --req"
  exit 1
fi
