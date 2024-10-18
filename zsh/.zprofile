# Path
export PATH=/usr/local/bin:/usr/sbin:/bin:/usr/bin:$HOME/bin:$HOME/.scripts:$HOME/opt:$HOME/go/bin:$HOME/.local/bin:$path[@]

# Chinese input stuff
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
	  exec startx
fi













































































































