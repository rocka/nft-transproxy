# nft-transproxy

## convention

- TPROXY target: `127.0.0.1:1080`

- packet fwmark: `0x233`

## ip rule for `TPROXY`

```console
# ip rule add fwmark 0x233 lookup 100
# ip route add local 0.0.0.0/0 dev lo table 100
```

## references

### iptables

- [iptables详解：图文并茂理解iptables](http://www.zsythink.net/archives/1199)

### nftables

- [包的路由转圈圈——谈谈使用nftables配置透明代理碰到的那些坑 | KosWu 's blog](https://koswu.github.io/2019/08/19/tproxy-config-with-nftables/)

- [透明代理(TPROXY) | 新 V2Ray 白话文指南](https://guide.v2fly.org/app/tproxy.html)
