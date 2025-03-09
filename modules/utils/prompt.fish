set -l last_status $status

set -l stat
if test $last_status -ne 0
    set stat (set_color -o red)"[$last_status] "(set_color normal)
end

set -l path (set_color -i blue)(prompt_pwd -D 4096)(set_color normal)

set -l prompt (set_color -o magenta)"> "(set_color normal)

set -l nix
if test -n "$IN_NIX_SHELL"
    set nix (set_color white)"❄ "(set_color normal)
end

set -l ssh
if test -n "$SSH_CLIENT"
    set ssh (set_color brblack)"$USER@$hostname"
end

set -l git
set -l IS_GIT_REPO (command git rev-parse --is-inside-work-tree &>/dev/null)
if test -n "$IS_GIT_REPO"
end

string join "" -- $stat $path \n $nix $prompt
