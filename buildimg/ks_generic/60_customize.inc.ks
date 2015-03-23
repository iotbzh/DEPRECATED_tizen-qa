%post

# tag the image
echo "@BRANCH@ @SNAPSHOT@ @FLAVOUR@ @MEDIUM@" >/etc/tizen-snapshot

# enable X11 forwarding on ssh
echo "X11Forwarding yes" >>/etc/ssh/sshd_config
echo "AddressFamily inet" >>/etc/ssh/sshd_config

# customize bash prompt 
# bashrc is badly named

cat >/etc/profile.d/bash_prompt_custom.sh <<'EOF'
# sdx@kooltux.org: customize prompt !
if [ "$PS1" ]; then

	function parse_git_branch {
		[ -x "/usr/bin/git" ] && git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
	}

	function proml {
		# set a fancy prompt (overwrite the one in /etc/profile)
		local default="\[\e[0m\]"
		local usercol='\[\e[1;34m\]' # blue
 		local hostcol='\[\e[1;32m\]' # green
		local pathcol='\[\e[1;33m\]' # yellow
		local gitcol='\[\e[1;31m\]' # light red
		local termcmd=''
		local _p="$";

		if [ "`id -u`" -eq 0 ]; then
			usercol='\[\e[1;31m\]'
			_p="#"
		fi

		PS1="${usercol}\u${default}@${hostcol}\h${default}:${pathcol}\w${default}${gitcol}\$(parse_git_branch)${default}${_p} ${termcmd}"
	}

	proml

	function rcd () {
      [ "${1:0:1}" == "/" ] && { cd $1; } || { cd $(pwd -P)/$1; }
   }

	alias ll="ls -lZ"
	alias lr="ls -ltrZ"
	alias la="ls -alZ"

	function dbus_find () {
		echo export	$(tr '\0' '\n' </proc/$(pgrep gnome-session)/environ |grep ^DB)
	}

	function get_manifest () {
		rpm -qa --queryformat="%{name} %{Version} %{Release} %{VCS}\n" | sort
	}
fi
EOF

%end
