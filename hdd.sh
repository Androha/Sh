#!/bin/bash
#apt install bc # You need to install calc first
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
    --req) req="$2" # Required amount of memory
           shift;;
    *) echo "$1 is not an option";;
  esac
  shift
done

mul=$(echo "$req" | sed 's/[^a-zA-Z]*//g') # Getting symbolic multiplyer
req=$(echo "$req" | sed 's/[^0-9.]*//g') # Getting numeric value of required amount

if [ "$req" != "" ]
then
  case "$mul" in
    M) req=$(echo "$req*1000" | bc) # Megabytes
       req=$(echo "($req+0.5)/1" | bc);;
    G) req=$(echo "$req*1000000" | bc) # Gigabytes
       req=$(echo "($req+0.5)/1" | bc);;
    *) req=$(echo "($req+0.5)/1" | bc);; # Ignore other multiplyers
  esac

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
    for tkn in $list
    do
      #Workfield
      free=$(df -k --output=avail / | tail -n1)
      if [[ $all == "false" && $free -gt $req ]]; then echo "Requirements are met"; exit 0; fi # Break if there is enough memory
      rm -r $tkn
      if [ $? -eq 0 ]; then echo "Token $tkn removed"; else echo "Failed to remove $tkn"; fi
    done
    exit 0;
  else
    echo "You must enter at least one file or folder to be removed.
It can be done via -f or -l options."
    exit 2
  fi

else
  echo "You must enter a valid requirement option with --req"
  exit 1
fi
