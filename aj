#!/usr/bin/env sh
### aj (apljack) --- Add code output to text mixed with GNU APL code
### Use: $ aj file
### Defaults
p=p           # Named pipe name
a=apl         # APL executable (path/)name. We assume it's on the exec path
f=$1          # File name
### Sanity checks, setup, and convenience things
command -v ${a}>/dev/null||(echo "GNU APL not found; check '$a' variable";exit 1)
[ ! -f "${f}" ]&&echo "File not found"&&exit 1
### Main
mkfifo p
${a} --script --OFF --noColor <p&
exec 3>p # Hack to keep the pipe open for multiple writes
export flag=0         # 1=we are on a code block; 0=we are not
export buf=""         # Buffer to hold code blocks for later processing
export nl="\n"        # Newline char
while read -r l;do
  if [ "${l}" = "{{{" ];then flag=1;fi # Starting a code block
  if [ "${l}" = "}}}" ];then           # Ending code block. Process it.
    flag=0
    echo ".-----APL-------"
    echo "${buf}"
    echo "'---------------"
    echo ".---Results-----"
    echo "${buff}">p # Feed the code buffer to APL by way of the named pipe
    echo "'---------------"
  fi
  if [ "${l}" != "}}}" ]&&[ "${l}" != "{{{" ]&&[ $flag = 0 ];then echo "${l}";fi
  if [ "${l}" != "}}}" ]&&[ "${l}" != "{{{" ]&&[ $flag = 1 ];then
    l=${l}${nl}
    buff=${buff:+${buff}, }${l};
  fi
done<"${f}"
rm $p 
