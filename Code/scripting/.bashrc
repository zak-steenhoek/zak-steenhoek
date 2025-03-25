# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software.
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

# base-files version 4.3-3

# ~/.bashrc: executed by bash(1) for interactive shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, 
# please feel free to customise it to create a shell
# environment to your liking.



# Begin user dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Programmable completion enhancements 
# are enabled via: 
# /etc/profile.d/bash_completion.sh when the package bash_completetion
# is installed.  Any completions you add in ~/.bash_completion are
# sourced last.

# History Options
#
# Don't put duplicate lines in the history.
# export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#

# Unused
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias l='ls -CF'                              # Colorize output, 
#
#
# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#

# Exported variables
export ME="/cygdrive/c/Users/zaste/OneDrive/"
export WE="/cygdrive/c/_Common/"
export MAT_DIR="/cygdrive/c/Users/zaste/OneDrive/Software/MATLAB"
export SEM_DIR="/cygdrive/c/Users/zaste/OneDrive/Documents/School/Junior/Spring"

# Some aliases for directory operations
alias ll='ls -l'                                # long list
alias llr='ls -lR'								# long list, recursive
alias lla='ls --format=vertical -lA'			# long list, all but [. ..]
alias llar='ls --format=vertical -lAR'			# long list, all but [. ..], recursive

# Misc 
alias clc='clear'
alias src='source ~/.bashrc'


# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
	
	# Change directory and list the files within
	cdl() {
		cd "$@" && lla
	}
	
	# Navigate to the local C:/<User>/ directory
	toC() {
		cdl /cygdrive/c/Users/zaste
	}
	
	# Navigate to personal OneDrive directory
	toMe() {
		cdl /cygdrive/c/Users/zaste/OneDrive/
	}
	
	# Navigate to the commons
	toWe() {
		cdl /cygdrive/c/_Common/zak-steenhoek
	}
	
	# Open a file with Notepad++
	npp() {
		local file="$1"
		(/cygdrive/c/Program\ Files/Notepad++/notepad++.exe "$(cygpath -w "$file")" &>/dev/null &)
	}
	
	# Open a file in MATLAB
	mat() {
		local file="$1"
		# echo "lol u thought"
		cscript.exe //nologo "C:\\cygwin\\home\\zaste\\bin\\OpenMatFile.vbs" "$(cygpath -w "$file")"
		#(cscript.exe //nologo "~/bin/OpenMatFile.vbs" "$(cygpath -w "$file")" &>/dev/null &) &>/dev/null
	}
	
	findme() {
		local search_pattern="$1"
    
		# Use find to get the full path of the file (case-insensitive)
		local filepath=$(find "$(pwd)" -type f -iname "*$search_pattern*" | head -n 1)

		if [ -z "$filepath" ]; then
			echo "No file matching '$search_pattern' found."
			return 1
		fi

		echo "Found you: $filepath"

		read -p "Jump to file location? Y/N [N]: " -n 1 -r
		echo

		if [[ "$REPLY" =~ ^[Yy]$ ]]; then
			local dirpath=$(dirname "$filepath")
			echo "Changing directory to: $dirpath"
			cd "$dirpath" || echo "Error: Could not change directory."
		else
			echo "Staying in current directory."
		fi
	}
	
	# Creates a new custom file 
	nFile() {
		local filename extension target_path
		read -rp "Enter file name (no extension): " filename
		read -rp "Enter desired file extension (without .): " extension
		read -rp "Enter target path [default: current dir]: " target_path
		target_path=${target_path:-$(pwd)}
		~/bin/MakeNewFile.sh custom "$filename" "$target_path" "$extension"
	}
	
	# Creates a new shell script
	nShell() {
		local filename
		read -rp "Enter shell script name: " filename
		~/bin/MakeNewFile.sh shell "$filename"
	}
	
	# Creates a new text file 
	nTxt() {
		local filename
		read -rp "Enter text file name: " filename
		~/bin/MakeNewFile.sh text "$filename"
	}
	
	# Creates a new MATLAB function 
	nMatF() {
		local filename
		read -rp "Enter MATLAB function name: " filename
		~/bin/MakeNewFile.sh matfunc "$filename"
	}
	
	# Creates a new MATLAB script 
	nMatS() {
		local filename
		read -rp "Enter MATLAB script name: " filename
		~/bin/MakeNewFile.sh matscript "$filename"
	}
	
	# Creates a new C++ file 
	nCpp() {
		local filename
		read -rp "Enter C++ file name: " filename
		# ~/bin/MakeNewFile.sh cpp "$filename"
		echo "Not done yet..."
	}
	
	# Creates a new Python file 
	nPy() {
		local filename
		read -rp "Enter Python script name: " filename
		# ~/bin/MakeNewFile.sh pyscript "$filename"
		echo "Not done yet..."
	}
	
# Some example functions:
#
# a) function settitle
# settitle ()
# {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }
#
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# 
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
#
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
#
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
#
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
#
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
#
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
#
#   return 0
# }
#
# alias cd=cd_func
#
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, ^this^ is public domain
#
