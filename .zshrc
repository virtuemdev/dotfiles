#===================================================================================================
# 
# DAVID STUFF
#
#===================================================================================================

PROMPT='%B%F{green}%n@%m:%F{blue}%1~%f%b$ '
# Enable vim mode (disable is trash. the plugin version much better
# builtin feels buggy an unusable! TRAHS)
# bindkey -v

HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

function cheat() {
    # Create a temporary file
    local tempfile=$(mktemp)
    # Download the file
    curl -o "$tempfile" "cht.sh/$1?T"
    # Open the file in Vim
    vim "$tempfile"
    # Remove the temporary file after Vim is closed
    rm "$tempfile"
}

function hist() {
    history 0 | fzf
}

function ff() {
    local ext=$1
    local result

    # Use the provided extension for filtering, if available
    if [[ -n $ext ]]; then
        result=$(rg --ignore-case --color=always --line-number --no-heading --glob "*.${ext}" . |
          fzf --ansi \
              --color 'hl:-1:underline,hl+:-1:underline:reverse' \
              --delimiter ':' \
              --preview "batcat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
              --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
    else
        result=$(rg --ignore-case --color=always --line-number --no-heading . |
          fzf --ansi \
              --color 'hl:-1:underline,hl+:-1:underline:reverse' \
              --delimiter ':' \
              --preview "batcat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
              --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
    fi

    if [[ -n $result ]]; then
      local file_name=$(echo "$result" | cut -d ':' -f 1)
      local line_number=$(echo "$result" | cut -d ':' -f 2)
      vim +"$line_number" "$file_name"
    fi
}


function fl() {
  file=$(rg . | fzf | cut -d ":" -f 1);
  if [ -n "$file" ]; then
    vim "$file";
  fi
}

function today() {
    date +"%a, %d.%m.%y"
}

function daysTill() {
    # Check if a date was provided
    if [ -z "$1" ]; then
        echo "Usage: daysTill DD.MM.YY"
        return 1
    fi

    # Convert DD.MM.YY to YYYY-MM-DD format to be used with date command
    local target_date_formatted=$(date -d "20${1:6:2}-${1:3:2}-${1:0:2}" +%Y-%m-%d)
    if [ $? -ne 0 ]; then
        echo "Invalid date format. Expected DD.MM.YY"
        return 1
    fi

    # Get the current date and the target date in seconds since 1970-01-01
    local current_date=$(date +%s)
    local target_date=$(date -d "$target_date_formatted" +%s)

    # Calculate the difference in seconds and then convert to days
    local diff_seconds=$((target_date - current_date))
    local days=$((diff_seconds / 86400))

    # If the date is in the past, the days value will be negative
    if [ "$days" -lt "0" ]; then
        echo "The date $1 is in the past."
    else
        echo "$days days until $1"
    fi
}

function ..() { 
  for i in $(seq 1 $1); do cd ..; done 
}

# SOURCE: https://nrk.neocities.org/articles/vim-gitlog
function glo() {
  git rev-parse 2> /dev/null || return 1
  local git_cmd="git --no-pager log --oneline --color=always ${@:--n 128}"
  vim \
    '+nnoremap q :bd!<CR>' '+nnoremap Q :qa!<CR>' \
    "+nnoremap <silent> K 0:tabnew \| setfiletype git \| exe 'read! git --no-pager show <C-r><C-w>' \| norm ggdd<CR>" \
    # If using vim not neovim use this as last line "+call term_start('$git_cmd', {'hidden': 1, 'term_cols': 2048, 'term_finish': 'open', 'term_opencmd': 'buffer %d'})"
    "+term $git_cmd"
}
