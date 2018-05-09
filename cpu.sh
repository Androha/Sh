#!/bin/bash
#apt install bc # You need to install calc first
names=false
all=false
file=""
list=""
req=""
while [ -n "$1" ]
do
  case "$1" in
    -a) all=true;; # Delete all
    -f) file="$2" # Get source from a file
        shift ;;
    -l) list+="$2 " # Get source from a list
        shift;;
    -n) names=true;; # Use process names instead of PIDs
    --req) req="$2" # Required amount of CPU
           shift;;
    *) echo "$1 is not an option";;
  esac
  shift
done

req=$(echo "$req" | sed 's/[^0-9.]*//g')

if [[ $req -lt 100 && $req != "" ]]
then

  if [ -f "$file" ] # Add file contents to the list of processes
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
      free=$(( $(echo "(100-$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }' | cut -d% -f1)+0.5)/1" | bc) ))
      if [[ $all == "false" && $free -gt $req ]]; then echo "Requirements are met"; exit 0; fi # Break if there is enough CPU and
      if [[ $names == "false" ]]                                                             # you don't need to kill all processes
      then
        kill $prc # Option for PIDs
        if [ $? -eq 0 ]; then echo "Process $prc killed"; else echo "Failed to kill $prc"; fi
      else
        pkill $prc # Option for process names
        if [ $? -eq 0 ]; then echo "Process $prc killed"; else echo "Failed to kill $prc"; fi
      fi
    done
    exit 0;
  else
    echo "You must enter at least one process to be killed.
It can be done via -f or -l options."
    exit 2
  fi

else
  echo "You must enter a valid requirement option with --req"
  exit 1
fi
