#!/bin/bash

# bypass individual ip address, eg. your proxy server
BYPASS_IPS=(
)

# chnroutes ipv6 url
BYPASS_ROUTE_URLS=(
    #https://raw.githubusercontent.com/PaPerseller/chn-iplist/master/chnroute-ipv6.txt
    #https://raw.fastgit.org/PaPerseller/chn-iplist/master/chnroute-ipv6.txt
    https://cdn.jsdelivr.net/gh/PaPerseller/chn-iplist/chnroute-ipv6.txt
)

# additional bypass ip
BYPASS_IPS+=(
::/128
::1/128
fe80::/10
fec0::/10
)

SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")
cd "$SCRIPT_PATH/../" || exit 1
INSTALL_HOME="$(pwd)"

OUTPUT="$INSTALL_HOME/nft/direct-ipv6.nft"

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
    echo "define direct_ipv6 = {"
    # routes
    for url in "${BYPASS_ROUTE_URLS[@]}"
    do
        curl -sL "$url" | sed '/^#/d; /^$/d; s/$/,/g'
    done
    # individual ip
    join_by $',\n' "${BYPASS_IPS[@]}"
    # footer
    echo ""
    echo -n "}"
}  > "$OUTPUT"
