
# ==============================================================================
# PROMPT SETTINGS
# ==============================================================================

# --- Redraw on Resize ---
# redrawing while using the zsh-users/zsh-syntax-highlighting plugin crashes
#function TRAPWINCH() {
	#zle && zle reset-prompt
#}

# --- Redraw on Keymap Select ---
function zle-keymap-select() {
	export ZSH_KEYMAP=$KEYMAP
	zle reset-prompt
	zle -R
}
zle -N zle-keymap-select

zle -N edit-command-line

# --- Redraw Every Minute ---
#function TRAPALRM() {
	#zle reset-prompt
#}
#TMOUT=60

# Alternative way to redraw every minute
#function periodic() {
#	zle reset-prompt
#}
#PERIODIC=60


# ==============================================================================
# POWERLINE FUNCTIONS
# ==============================================================================

# --- Check Powerline ---
function _set-powerline() {
	export POWERLINE=$(fc-cat $HOME/.fonts 2>/dev/null | command grep -io -m 1 powerline)
}
_set-powerline


# ==============================================================================
# LEFT PROMPT FUNCTIONS
# ==============================================================================

# --- Prompt Background ---
function _prompt-bg() {
	local bg="%{%K{$1}%}"
	echo -n ${bg/\%K\{reset\}/%k}
	if [[ $PROMPT_BG != 'NONE' && $PROMPT_BG != $1 ]]; then
		echo -n "%F{$PROMPT_BG}%}$PROMPT_SEPARATOR"
	fi
	PROMPT_BG=$1
}

# --- Prompt Foreground ---
function _prompt-fg() {
	local fg="%{%F{$1}%}"
	shift && echo -n "${fg/\%F\{reset\}/%f}$@"
}

# --- Prompt Background/Foreground ---
function _prompt-bg-fg() {
	_prompt-bg $1
	shift && _prompt-fg $@
}

# --- Prompt End ---
function _prompt-end() {
	_prompt-bg-fg reset reset
	[[ -n $POWERLINE ]] || echo -n "$no_color "
}


# ==============================================================================
# RIGHT PROMPT FUNCTIONS
# ==============================================================================

# --- Right Prompt Background ---
function _rprompt-bg() {
	local bg="%{%K{$1}%}"
	echo -n "%F{$1}%}$RPROMPT_SEPARATOR"
	echo -n ${bg/\%K\{reset\}/%k}
}

# --- Right Prompt Foreground ---
function _rprompt-fg() { _prompt-fg $@; }

# --- Right Prompt Background/Foreground ---
function _rprompt-bg-fg() {
	_rprompt-bg $1
	shift && _rprompt-fg $@
}

# --- Right Prompt Start ---
function _rprompt-start() {
	if [[ -n $POWERLINE ]]; then
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"
		PROMPT_SEPARATOR=$'\ue0b0'
		RPROMPT_SEPARATOR=$'\ue0b2'
	else
		PROMPT_SEPARATOR=' '
		RPROMPT_SEPARATOR=' '
	fi
}

# --- Right Prompt End ---
function _rprompt-end() {
	#[[ $KEYMAP == vicmd ]] && prompt_bg_fg black white || prompt_bg_fg reset reset
}

