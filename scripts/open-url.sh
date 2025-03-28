#!/usr/bin/env bash

urls=(
  # 'https://music.163.com/download'
  # 'https://im.qq.com/macqq/'
  # 'https://mac.weixin.qq.com/'
  # 'https://page.dingtalk.com/wow/dingtalk/act/download'
  # 'https://github.com/shadowsocks/ShadowsocksX-NG/releases'

  # 'https://gfycat.com/gifbrewery'
  # 'https://store.steampowered.com/about/'
  # 'https://xclient.info/s/sizeup.html'
  # 'https://xclient.info/s/istat-menus-for-mac.html'
  # 'https://xclient.info/s/pdf-expert-for-mac.html'

  'https://xclient.info/s/alfred.html'
  'https://pinyin.sogou.com/mac'
)

for url in "${urls[@]}"; do
  open "$url"
done
