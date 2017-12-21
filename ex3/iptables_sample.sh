#!/bin/sh

PATH=/sbin:/bin:/usr/bin:/usr/sbin

## 変数の定義
EXTERNAL_INTERFACE="eth0"       # 外側インタフェースの名前
INTERNAL_INTERFACE="eth1"       # 内側インタフェースの名前

# 外側インタフェースのIPアドレス
IPADDR=`ifconfig $EXTERNAL_INTERFACE | \
 sed -e 's/^.*inet[^:]*:\([^ ]*\).*$/\1/p' -e d`
# 外部ネットワークのブロードキャスト・アドレス
BCAST=192.168.100.255
# 内部ネットワークのブロードキャスト・アドレス
INTERNAL_BCAST=192.168.200.255
# 内部ネットワーク・アドレスのネットマスク長
INTERNAL_MASK=255.255.255.0
# 内部ネットワーク・アドレス
INTERNAL_LAN_X=192.168.200.1

INTERNAL_LAN=$INTERNAL_LAN_X/$INTERNAL_MASK

ANYWHERE="0.0.0.0/0"

## 以下の設定を実行している間はパケットの転送を停止する
echo 0 > /proc/sys/net/ipv4/ip_forward

## すでに設定されているルールを消去する
iptables -F
iptables -F -t nat

## ポリシーの初期設定
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

## ループバック・インタフェースの入出力を許可する
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

##############################################################################
##
## INPUTチェーンの設定（デフォルト拒否）
##
iptables -N DROP
##############################################################################
##
## OUTPUTチェーンの設定（デフォルト拒否）
##
iptables -N DROP
##############################################################################
##
## FORWARDチェーンの設定（デフォルト拒否）
##
iptables -N DROP
##############################################################################
##
## NATの設定
##

## 端末型接続の場合は IP masquerade
iptables -A POSTROUTING -t nat -o $EXTERNAL_INTERFACE -j MASQUERADE

##############################################################################
##
## 設定の保存
##
#/etc/init.d/iptables save active

## パケットの転送を開始する
echo 1 > /proc/sys/net/ipv4/ip_forward

exit 0