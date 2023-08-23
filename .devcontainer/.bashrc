export GH_TOKEN=$(cat ~/.gh/token)

# return the git branch
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# return terraform workspace if there is a .tf file in teh current directory
tf_workspace() {
  count=`ls -1 *.tf 2>/dev/null | wc -l`
  if [ $count != 0 ]; then
    ws=$(terraform workspace show 2> /dev/null)
    echo "$ws " # space for prompt formatting
  else
      echo ""
  fi
}

set_bash_prompt(){
  blue=$(tput setaf 4)
  green=$(tput setaf 2)
  red=$(tput setaf 1)
  magenta=$(tput setaf 5)
  cyan=$(tput setaf 6)
  reset=$(tput sgr0)
  PS1="\[$blue\]\u \[$green\]\w\[$red\]\[\$(parse_git_branch) \]\[$magenta\]\[\$(tf_workspace)\]\[$cyan\]$ \[$reset\]"
}

PROMPT_COMMAND=set_bash_prompt

# run tfswitch if directory contains a *.tf file
cdtfswitch() {
  builtin cd "$@";
  cdir=$PWD;
  count=`ls -1 *.tf 2>/dev/null | wc -l`
  if [ $count != 0 ]; then
    tfswitch
  fi
}
alias cd='cdtfswitch'

# alias for terraform workspace select
alias tws='terraform workspace select'

# uses expect to set up git commit message
# changes the shell to expect and you lost history
# somebody please fix
git_commit_prompt() {
branch=$(parse_git_branch | tr -d ' ' | tr -d '(' | tr -d ')')
expect -c "
log_user 0
spawn bash -l
log_user 0
send \"git commit -m '\[$branch\] \"
interact
exit
"
}

alias gitc='git_commit_prompt'

alias ll='ls -laG'

alias gfp='git fetch; git pull'