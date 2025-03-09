set -l last_status $status

set -l stat
if test $last_status -ne 0
    set stat (set_color -o red)"[$last_status] "(set_color normal)
end

set -l path (set_color -i blue)"$(prompt_pwd -D 4096) "(set_color normal)

set -l prompt (set_color -o magenta)"> "(set_color normal)

set -l nix
if test -n "$IN_NIX_SHELL"
    set nix (set_color white)"❄ "(set_color normal)
end

set -l ssh
if test -n "$SSH_CLIENT"
    set ssh (set_color brblack)"$USER@$hostname "(set_color normal)
end

set -l git
set -l is_git (command git rev-parse --is-inside-work-tree 2>/dev/null)
if test -n "$is_git"

    set -l branch (git branch --show-current)
    if test -z $branch
        set branch "detached HEAD"
    end

    set -l clean
    set -l is_dirty (command git status --porcelain)
    if test -n "$is_dirty"
        set clean "*"
    end

    set git (set_color brblack)"$clean$branch "(set_color normal)
end

string join "" -- $stat $path $git $ssh \n $nix $prompt
