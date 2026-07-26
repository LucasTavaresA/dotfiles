#!/usr/bin/env fish
set white "\033[37m"
set green "\033[32m"
set blue "\033[34m"
set red "\033[31m"
set cyan "\033[36m"
set bold "\033[1m"
set dim "\033[2m"
set reset "\033[0m"

read -l input
set user (whoami)
set hostname (hostname)

set cwd (echo "$input" | jq -r '.cwd')
set short_cwd (prompt_pwd --dir-length=1 --full-length-dirs=4 "$cwd")

set model (echo "$input" | jq -r '.model.display_name')
set effort (echo "$input" | jq -r '.effort.level // empty')

[ -z "$effort" ] && set effort unknown

set git_branch ""
set git_status ""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1
    set git_branch (git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    set git_dirty (git -C "$cwd" -c core.hooksPath=/dev/null status --porcelain 2>/dev/null)
    if [ -n "$git_dirty" ]
        set git_status " !"
    end
end

set vim_mode ""
set vim_raw (echo "$input" | jq -r '.vim.mode // empty')
if [ -n "$vim_raw" ]
    switch "$vim_raw"
        case INSERT set vim_mode "$green [I]$reset"
        case NORMAL set vim_mode "$white [N]$reset"
        case VISUAL set vim_mode "$blue [V]$reset"
        case "VISUAL LINE" set vim_mode "$blue [VL]$reset"
        case REPLACE set vim_mode "$red [R]$reset"
        case * set vim_mode " [$vim_raw]"
    end
end

set ctx ""
set used (echo "$input" | jq -r '.context_window.used_percentage // empty')
[ -n "$used" ] && set ctx (printf " ctx:%.0f%%" "$used")

#### status line ####
printf "$green%s@%s$reset $bold$cyan%s$reset" "$user" "$hostname" "$short_cwd"

if [ -n "$git_branch" ]
    printf " $green(%s%s)$reset" "$git_branch" "$git_status"
end

printf "%b" "$vim_mode"
printf " $dim%s %s%s$reset" "$model" "on $effort effort" "$ctx"
