#!/bin/bash

# bypass individual ip address, eg. your proxy server
BYPASS_IPS=(
)

# /path/to/chnroutes.txt 
BYPASS_ROUTE_FILES=(
)

# chnroutes url
BYPASS_ROUTE_URLS=(
https://github.com/misakaio/chnroutes2/raw/master/chnroutes.txt
https://github.com/felixonmars/chnroutes-alike/blob/master/chnroutes-alike.txt
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

# 1. delete line starts with '#'
# 2. delete empty lines
# 3. append ',' to every line
SED_CMD='/^#/d; /^$/d; s/$/,/g'

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
    # route files
    for file in "${BYPASS_ROUTE_FILES[@]}"
    do
        sed "$SED_CMD" "$file"
    done
    # route urls
    for url in "${BYPASS_ROUTE_URLS[@]}"
    do
        curl -sL "$url" | sed "$SED_CMD"
    done
    # individual ip
    join_by $',\n' "${BYPASS_IPS[@]}"
    # footer
    echo -n "}"
}  > "$OUTPUT"
