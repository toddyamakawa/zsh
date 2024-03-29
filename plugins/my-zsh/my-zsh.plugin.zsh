
# --- Source Files ---
local here=${0:h}
source $here/my-completion.zsh
source $here/my-options.zsh
source $here/my-builtins.zsh
for sourcefile in $here/alias/*.zsh; do
	source $sourcefile
done


# --- Path ---
function addpath() { export PATH=$PATH:$1; }

function echo_eval() {
	echo "$@"
	eval "$@"
}


# --- zsh ---
function zsh-theme() {
	if [[ -f $ZSH/themes/$1.zsh-theme ]]; then
		ZSH_THEME=$1
		zshrc
	else
		if [[ -z $1 ]]; then
			unset ZSH_THEME
			zshrc
		else
			echo "Unable to find theme: $1"
		fi
	fi
}

# --- stderr ---
alias -g 2null='2>/dev/null'
alias -g 2out='2>&1'
alias -g P='|&'

# --- Time ---
function now() { date +%y%m%d-%H%M%S-Week%V-%a-%T; }
alias week="date +%V"

# --- General ---
alias func='print -l ${(ok)functions}'
alias funcg='print -l ${(ok)functions} | grep'

alias findn='find . -name'

alias sortn='sort -n'
alias usort='sort | uniq -c | sort -n'

# --- General ---
alias wrap="printf '\033[?7h'"
alias nowrap="printf '\033[?7l'"
alias tab2="expand -t2"
alias tab4="expand -t4"
alias tab8="expand -t8"
alias cutw='cut -c 1-$COLUMNS'

alias lns='ln -s'
alias lnsf='ln -sf'

alias mkts='mkdir -v $(now)'

alias catn='cat -n'
alias tailf='tail -n 100 -F'

function powerline_check() {
	echo "Symbols: \ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
	echo "fc-list: $(fc-list | grep -i powerline)"
	echo "xlsfonts: $(xlsfonts | grep -i powerline)"
}

alias .tar='tar xf'
alias .tar.bz2='tar xjf'
alias .tar.gz='tar xzf'

alias l='ls -lAh'
alias ll='ls -lrth'
alias lll='ll | grep "\->"'
alias lsd='ls -dl */'
alias lla='ll -a'

alias du1='du --max-depth=1'
alias du2='du --max-depth=2'
alias du3='du --max-depth=3'

# Kakoune
# https://discuss.kakoune.com/t/align-align-things/1481
alias align="kak -f '<a-s><S>\h<ret><a-semicolon><&>'"



# --- ps ---
alias psf='ps --forest'
alias killps="grep -v grep | awk '{print \$2}' | xargs kill"



# ==============================================================================
# FUNCTIONS
# ==============================================================================

# Grep URLs
# https://github.com/salman-abedin/puri/blob/master/puri.sh
function gurl() {
	grep -Pzo '(http|https)://[a-zA-Z0-9+&@#/%?=~_|!:,.;-]*\n*[a-zA-Z0-9+&@#/%?=~_|!:,.;-]*' "$@" |
	tr -d '\n' |
	sed -e 's/http/\nhttp/g' -e 's/$/\n/' |
	sed '1d' | sort -u
}

alias ascii='man ascii'

# which
function catw() {
	local file
	file="$(whence -c $1)"
	if (bat -h &>/dev/null); then
		bat "$file"
	else
		echo "$file"
		echo '================================================================================'
		cat -n "$file"
	fi
}
function viw() {
	vi "$(whence -c $1)"
}

# TODO: Move this to autoload
which colordiff &> /dev/null && alias diff='colordiff -w'

alias suu='su $(whoami)'

alias weather='curl "wttr.in/austin?u"'

function blank() { dd if=/dev/zero of=blank"$1"M.bin bs=1M count=$1; }

function setdisp() {
	[[ -n $LSB_BATCH_JID ]] && return
	[[ -z $VNCDESKTOP ]] && return
	port=$(echo $VNCDESKTOP | awk 'match($1, /.*(:[0-9]+)/, groups) {print groups[1]}')
	export DISPLAY=$port.0
}

# Delete current directory
function rmrf.() {
	local d=${PWD##*/}
	cd .. && rmrf $d
}

function cp1() {
	local dir=$1
	mkdir $(basename $dir)
	cp $dir/* $(basename $dir)
}

# TODO: Fix this
function xargsi() {
	xargs -I% sh -c "$@"
}

function pme() {
	psort | grep $USER | awk '($NF != "-zsh") {$8="\033[1;34m"$8"\033[0m"; print}'
}

# --- Colors ---
function zsh_colors() {
	for color in RED YELLOW GREEN BLUE CYAN MAGENTA BLACK WHITE; do
		echo "$fg_bold[${(L)color}]BOLD $fg_no_bold[${(L)color}]$color"
	done
}

# compdefs
# Source: https://stackoverflow.com/questions/40010848/how-to-list-all-zsh-autocompletions
function compdefs() {
	#for command completion in ${(kv)_comps:#-*(-|-,*)}; do
	for command completion in ${(kv)_comps}; do
		printf "%-32s %s\n" $command $completion
	done | sort
}

