# Path
export PATH=/usr/local/bin:/usr/sbin:/bin:/usr/bin:$HOME/bin:$HOME/.scripts:$HOME/opt:$HOME/go/bin:$HOME/.local/bin:$path[@]

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  exec startx
fi





















































































































