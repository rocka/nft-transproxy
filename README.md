# nft-transproxy

TCP/UDP transparent proxy with predefined bypass address set, using nftables `tproxy` target.

## convention

- TPROXY target: `127.0.0.1:1080` and `::1:1080`

- reroute packet fwmark: `0x233`

- ip rule and route:

    ```console
    # ip rule add fwmark 0x233 lookup 100
    # ip route add local 0.0.0.0/0 dev lo table 100
    # ip -6 rule add fwmark 0x233 lookup 100
    # ip -6 route add local ::/0 dev lo table 100
    ```

    See also `ExecStartPost` and `ExecStopPost` in [systemd service file](./systemd/tproxy-nft-ip-rule.service).

## installation

```console
# git clone https://github.com/rocka/nft-transproxy.git /usr/local/lib/nft-transproxy
# ln -sf /usr/local/lib/nft-transproxy/systemd/tproxy-nft-ip-rule.service /etc/systemd/system/
# vim /usr/local/lib/nft-transproxy/scripts/make-direct-ipv{4,6}.sh # important! specify bypass IP (typically your proxy server)
# /usr/local/lib/nft-transproxy/scripts/make-direct-ipv{4,6}.sh # generate nft/direct-ipv{4,6}.nft
# systemctl enable --now tproxy-nft-ip-rule.service
```

## todo

- [ ] proxy packet from other host as gateway

## references

### iptables

- [iptables详解：图文并茂理解iptables](http://www.zsythink.net/archives/1199)
- [金枪鱼之夜：坏人的 iptables 小讲堂](https://www.youtube.com/watch?v=w_vGD-96O54)
- [金枪鱼之夜：坏人的 iptables 小讲堂第二弹](https://www.youtube.com/watch?v=Vnh8hYk6wZE)
- [Linux transparent proxy support](https://powerdns.org/tproxydoc/tproxy.md.html)
- [Transparent Proxying Patches, Take 3 [LWN.net]](https://lwn.net/Articles/252545/)
- [iptables(8) | Arch manual pages](https://man.archlinux.org/man/core/iptables/iptables.8.en)
- [iptables-extensions(8) | Arch manual pages](https://man.archlinux.org/man/core/iptables/iptables-extensions.8.en)

### nftables

- [包的路由转圈圈——谈谈使用nftables配置透明代理碰到的那些坑 | KosWu 's blog](https://koswu.github.io/2019/08/19/tproxy-config-with-nftables/)
- [透明代理(TPROXY) | 新 V2Ray 白话文指南](https://guide.v2fly.org/app/tproxy.html)
- [ipv6透明代理 - 小學霸](https://xuebaxi.com/blog/2020_09_05_01)
- [nftables初体验 | I'm OWenT](https://owent.net/2020/2002.html)
- [owent-utils/docker-setup](https://github.com/owent-utils/docker-setup/blob/master/setup-router/v2ray/setup-tproxy.nft.sh)
- [nftables wiki](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
  - [Configuring chains](https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains)
  - [Quick reference-nftables in 10 minutes](https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes)
- [nft(8) | Arch manual pages](https://man.archlinux.org/man/nft.8)
