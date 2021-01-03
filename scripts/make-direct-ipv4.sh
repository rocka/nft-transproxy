#!/bin/bash

# bypass individual ip address, eg. your proxy server
BYPASS_IPS=(
)

# /path/to/chnroutes.txt 
BYPASS_ROUTE_FILES=(
/usr/share/chnroutes2/chnroutes.txt
/usr/share/chnroutes-alike/chnroutes-alike.txt
)

# private ipv4 address
BYPASS_IPS+=(
0.0.0.0/8
10.0.0.0/8
127.0.0.0/8
169.254.0.0/16
172.16.0.0/12
192.168.0.0/16
224.0.0.0/4
240.0.0.0/4
)

SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")
cd "$SCRIPT_PATH/../" || exit 1
INSTALL_HOME="$(pwd)"

OUTPUT="$INSTALL_HOME/nft/direct-ipv4.nft"

# https://stackoverflow.com/a/17841619/8370777
function join_by {
    local d=$1;
    shift;
    local f=$1;
    shift;
    printf %s "$f" "${@/#/$d}";
}

{
    # header
    echo "define direct_ipv4 = {"
    # routes
    for file in "${BYPASS_ROUTE_FILES[@]}"
    do
        sed '/^#/d; /^$/d; s/$/,/g' "$file"
    done
    join_by $',\n' "${BYPASS_IPS[@]}"
    # footer
    echo ""
    echo -n "}"
}  > "$OUTPUT"
