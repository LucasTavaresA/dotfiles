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

echo "$input" | jq -r '[
    .cwd,
    .model.display_name,
    (.effort.level // ""),
    (.vim.mode // ""),
    (.context_window.used_percentage // ""),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // "")
] | @tsv' | read -d \t -l cwd model effort vim_mode context_used 5h_used 5h_reset_timestamp week_used

set user $USER
set short_cwd (prompt_pwd --dir-length=1 --full-length-dirs=4 "$cwd")

[ -z "$effort" ] && set effort unknown

set git_branch ""
set git_status ""
set git_oid ""
for line in (git -C "$cwd" -c core.hooksPath=/dev/null status --porcelain=v2 --branch 2>/dev/null)
    switch $line
        case '# branch.head *'
            set git_branch (string replace -- '# branch.head ' '' $line)
        case '# branch.oid *'
            set git_oid (string replace -- '# branch.oid ' '' $line)
        case '#*'
        case '*'
            set git_status " !"
    end
end
[ "$git_branch" = "(detached)" ] && set git_branch (string sub -l 7 -- "$git_oid")

if [ -n "$vim_mode" ]
    switch "$vim_mode"
        case INSERT
            set vim_mode "$green [I]$reset"
        case NORMAL
            set vim_mode "$white [N]$reset"
        case VISUAL
            set vim_mode "$blue [V]$reset"
        case "VISUAL LINE"
            set vim_mode "$blue [VL]$reset"
        case REPLACE
            set vim_mode "$red [R]$reset"
        case '*'
            set vim_mode " [$vim_mode]"
    end
end

set ctx ""
[ -n "$context_used" ] && set ctx (printf " ctx:%.0f%%" "$context_used")

set limits ""
[ -n "$5h_used" ] && set limits "$limits"(printf " 5h:%.0f%%" "$5h_used")
if [ -n "$5h_reset_timestamp" ]
    set 5h_resets_at (date -d "@$5h_reset_timestamp" +%X 2>/dev/null | string replace -r '^(\d{1,2}:\d{2}):\d{2}' '$1')
    [ -n "$5h_resets_at" ] && set limits "$limits"(printf " (resets at %s)" "$5h_resets_at")
end
[ -n "$week_used" ] && set limits "$limits"(printf " 7d:%.0f%%" "$week_used")

#### status line ####
printf "$green%s@%s$reset $bold$cyan%s$reset" "$user" "$hostname" "$short_cwd"

if [ -n "$git_branch" ]
    printf " $green(%s%s)$reset" "$git_branch" "$git_status"
end

printf "%b" "$vim_mode"
printf " %s %s%s%s" "$model" "on $effort effort" "$ctx" "$limits"
