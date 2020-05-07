
local here=${0:h}
source $here/symbols.zsh

source $here/directory.zsh
source $here/display.zsh
source $here/host.zsh
source $here/pre.zsh
source $here/projects.zsh
source $here/prompt.zsh
source $here/svn.zsh
source $here/time.zsh
source $here/tmux.zsh

# --- Prompt Performance ---
function pperf() {
	_perf preexec
	_perf precmd
	_perf build_prompt
	_perf build_rprompt
}

function _perf() {
	local _start_ms=$(date +%s%3N)
	$@ > /dev/null
	echo "$1: $(($(date +%s%3N)-$_start_ms))"
}

# --- Set Title ---
function _set-title() {
	print -Pn "\e]0;$@\a"
}

# --- Set Prompt Version ---
function _prompt-git-version() {
	git -C $here log -1 --format=%H 2>/dev/null || echo none
}
_prompt_git_version=$(_prompt-git-version || echo fail)

