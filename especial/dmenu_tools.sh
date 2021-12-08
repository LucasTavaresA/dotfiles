function join
{
    local IFS="$1"
    shift
    echo "$*"
}

function menu
{
    # Grab the prompt message.
    local prompt="$1"
    shift

    # Combine the rest of our arguments.
    local items=$(join $'\n' "$@")

    dmenu -i -l 37 -g 1 -p "${prompt}" <<< "${items}" | tail -1
}

function confirm
{
    menu "$*" 'No' 'Yes'
}

function alert
{
    menu "$*" 'OK'
}
