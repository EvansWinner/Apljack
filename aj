#!/usr/bin/env sh
### aj (apljack) --- Add code output to text mixed with GNU APL code

### Use: $ aj file

### Defaults
a=apl         # APL executable (path/)name. We assume it's on the exec path
arg="--script --OFF --noColor"
f=$1          # Name of file to process
t=1           # Timeout time. Yes, this is horrible

### Sanity checks and setup
command -v ${a}>/dev/null||(echo "GNU APL not found; check '$a' variable";exit 1)
[ ! -f "${f}" ]&&echo "File not found"&&exit 1
p=$(mktemp -u)        # Named pipe name
mkfifo ${p}         # Make the named pipe

### Main
#exec 3<> "${p}"
export flag=0         # 1=we are on a code block; 0=we are not
#"${a}" ${arg}<&3 & # Start APL in the background
"${a}" ${arg} <>"${p}" & # Start APL in the background\
pid=$!                # Get the PID of APL
export buff=""        # Buffer to hold code blocks for later processing
export nl="\n"        # Newline char
while read -r l;do
  if [ "${l}" = "{{{" ];then flag=1;fi   # Starting a code block
  if [ "${l}" = "}}}" ];then             # Ending code block. Process it.
    flag=0
    echo ".-APL-----------------------------------"
    echo
    printf "${buff}" | sed "s/^/     /" # sed - indents for aesthetic reasons
    echo
    echo "'---------------------------------------"
    echo ".-Results-------------------------------"
    echo
    echo "${buff}">"${p}" # Feed the code buffer to APL by way of the named pipe
    timeout $t cat /proc/$pid/fd/1
    buff=""
    echo
    echo "'---------------------------------------"
  fi
  if [ "${l}" != "}}}" ]&&[ "${l}" != "{{{" ]&&[ $flag = 0 ];then echo "${l}";fi
  if [ "${l}" != "}}}" ]&&[ "${l}" != "{{{" ]&&[ $flag = 1 ];then
    l="${l}\n"
    buff="${buff}${l}";
  fi
done<"${f}"
echo ")off">"${p}"
rm -f "${p}"}
{ kill -9 ${pid} && wait ${pid} ; } 2>/dev/null
{ kill -9 $(ps|grep APserver|cut -f 1 -d' ') ; } 2>/dev/null

