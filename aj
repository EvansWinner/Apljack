#!/usr/bin/env sh
### aj (apljack) --- Add code output to text mixed with GNU APL code
### Use: $ aj file
### Defaults
t=1           # IMPORTANT: This is the timeout in seconds after every call
              # before disconnecting from the apl session. If you make this too
              # short, you will disconnect before you've gotten your results
              # back from apl.
p=9384        # TCP port. Unassigned per https://www.speedguide.net/port.php?port=9385
a=apl         # APL executable (path/)name. We assume it's on the exec path
f=$1          # File name
### Sanity checks, setup, and convenience things
h=$(hostname)
command -v ${a}>/dev/null||(echo "GNU APL not found; check '$a' variable";exit 1)
[ ! -f "${f}" ]&&echo "File not found"&&exit 1
### Main
${a} --tcp_port ${p}& # Start APL as TCP server. Persists til the program done.
sleep 1
export flag=0         # 1=we are on a code block; 0=we are not
export buf=""         # Buffer to hold code blocks for later processing
while read -r l;do
  if [ "${l}" = "{{{" ];then flag=1;fi # Starting a code block
  if [ "${l}" = "}}}" ];then           # Ending code block. Process it.
    flag=0
    echo ".-----APL-------"
    echo "${buf}"
    echo "'---------------"
    echo ".---Results-----"
    echo "${buff}"|timeout $t nc "${h}" "${p}" # Feed the code buffer to APL
    echo "'---------------"
    fi
  if [ "${l}" != "}}}" ]&&[ "${l}" != "{{{" ]&&[ $flag = 0 ];then echo "${l}";fi
  if [ "${l}" != "}}}" ]&&[ "${l}" != "{{{" ]&&[ $flag = 1 ];then buff=${buff:+${buff}, }${l};fi
done<"${f}"
echo ")off"|timeout $t nc $h $p # Disconnect

