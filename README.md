# mac-config
- 在这组织我的 mac 配置，定义一些脚本方便快速重装、迁移、同步配置
- 同时记录一些配置和技巧

## 使用
- 直接执行 init.sh 脚本即可，install.sh 脚本也可单独执行

### 执行脚本
- init.sh
- install.sh

#### init.sh
- 初始化脚本，建立文件夹，克隆 mac-config 项目到指定目录，执行 install.sh 脚本
- 无依赖直接使用方式
- `sh -c "$(curl -fsSL https://raw.githubusercontent.com/TaumuLu/mac-config/master/init.sh)"`

#### install.sh
- 安装执行脚本，安装 rvm、zsh，引入公共库并 source install 和 script 目录下的脚本
- 执行 init.sh 时会自动执行，也可进入项目目录下执行
- `./install.sh`

## 脚本目录

### install
目录下的脚本依赖 install.sh 脚本调用，无法单独执行

- brew
  - 脚本中的变量 brewList、brewCaskList 定义了安装软件的列表
  - 安装所有 brew 及 cask 列表中的软件，会跳过已安装过的软件
  - 安装完成后执行 brew services 注册服务
  - 运行 duti 命令关联文件打开方式
  - 初始化操作，安装 fzf 等
- flutter
  - 安装 flutter
- node
  - 安装 node
  - npm install 列表里的全局包
- vim
  - 安装 spf13_vim

### script
一些脚本处理，包括 bash 公共工具库

- links.py
  - 需要 python3 环境，软链接 dotfilts 文件脚本，根目录下执即可，需要链接的地址可以自定义修改链接地址
  - 参数 -i 忽略已创建相同的链接文件
  - 参数 -f 强制创建链接覆盖目标文件/文件夹
- links.sh
  - 无依赖 link 脚本，简单的先 link 必要文件配置
- mac-setting
  - [defaults-write](https://www.defaults-write.com)
  - defaults 命令可以访问和修改 Mac 系统的默认设置
- open-url
  - 无法通过 brew 安装的软件，直接打开浏览器地址手动下载
- common
  - 公共函数库

## 配置目录
通过软链统一管理软件配置，链接了以下文件/文件夹

### dotfilts
- .bash_profile
- .bashrc
- .gitconfig
- .npmrc
- .vimrc
- .zshrc
- config.ini
  - snipaste 配置文件
- proxychains.conf

### configs
- .hammerspoon
- .SwitchHosts
- karabiner

#### karabiner
键盘改键软件，有多种方案配置，目前主要为将 caps lock 按键改为点按为 esc，长按为 control


## hammerspoon
- 自动化工具，可以通过写 lua 脚本去实现想要的功能，目前写了以下脚本

### 目录结构
- appWatch 监听切换 app 进入/离开时执行一些操作，index.lua 为入口文件
  - finderApp
    - 绑定快捷键 cmd+d 删除操作
    - 绑定快捷键 cmd+x/cmd+v 剪切操作
  - hideApp
    - 隐藏 app 快捷键绑定，暂无用
  - safariApp
    - 绑定 cmd+alt+j 切换开发者工具，统一 chrome 快捷键
  - switchTab
    - 绑定快捷键 cmd+alt+left/right 切换多个 tab，适用于 finder/safari
  - yuqueWeb
    - 为浏览器的语雀提供的脚本
    - 目的是粘贴文本时不带样式，同时保留统一 url 类型的粘贴样式
- caffWatch 监听电脑锁屏/休眠时执行一些操作，index.lua 为入口文件
  - connectAirPods
    - 屏幕锁定解锁自动开启/关闭蓝牙
    - 同时绑定快捷键连接蓝牙设备，通过 name 变量定义要连接的设备名称
    - alt+l 自动连接 airpods，alt+shift+l 自动断开
  - killApp
    - 睡眠时杀死一些 app 防止耗电，比如 ios 模拟器就很耗电
  - setVolume
    - 解锁时自动设置声音大小，会根据当前 wifi 名判断环境是否需要开启音量
- autoReload
  - 修改脚本后自动加载 hammerspoon
- posMouse
  - 多显示器快速切换定位鼠标
  - alt+` 切换鼠标到下一显示器，并且定位在其屏幕中间，且触发点击聚焦屏幕
- stateCheck
  - 检查 hammerspoon 状态，提供快捷键显示/隐藏 dock 图标，方便调试
- resetLaunch
   - 检测 app 路径是否有改动，有改动会重置 launch 并重开 Dock 进程
- hotkey
  - 绑定全局快捷键
  - 目前有 cmd+l 对齐 win 的锁屏快捷键
  - 目前有 cmd+h 隐藏当前 app 快捷键

## data目录
存储相关的脚本数据

- data.js
  + SwitchHosts 初始数据
- duti
  + duti 配置数据

### duti
- 通过 duti 命令修改文件的默认打开方式，目前定义了 sublime 和 vscode
- 文件类型可通过 mdls 命令查询
  - `mdls <filePath>`

## 命令片段

### 查看当前shell
```bash
echo $SHELL
ps -p $$
```

### 清除DNS缓存
```
sudo killall -HUP mDNSResponder
sudo killall mDNSResponderHelper
sudo dscacheutil -flushcache
```

### 列出app store安装的应用
```
find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'
```

## 其他
- 如果当前 shell 为 zsh，则不会加载 bash 相关文件，如需要加载，在 .zshrc 中写入 source 引用 bash 配置
- 如果追求零配置 shell 推荐使用 fish

### 保存iterm2配置
- 打开 iTerm2 时创建一个默认文件 com.googlecode.iterm2.plist
- 删除 iterm2 的所有缓存首选项：defaults delete com.googlecode.iterm2
- 将文件复制到 Preferences 文件夹中，恢复旧的配置文件和设置
- 读取配置 defaults read -app iTerm 或运行 defaults read com.googlecode.iterm2
- 或者 killall cfprefsd
- 打开 iTerm2

### QuickLook
- [quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)

### 模拟慢速网络
- xcode 工具[Network Link Conditioner](https://www.jianshu.com/p/343aa3a65c5c)
- 在 Additional tools for Xcode 目录下载

### 快捷键
- control+shift+power 息屏，程序继续运行
- command+option+power 睡眠，等于合盖
- control+power 显示重启、关机、睡眠对话框
- command+control+power 重新启动

### 设置开机自启
- 利用 Launchctl 来设置，通过写在 /Library/LaunchDaemons/ 下的 .plist 文件
- 通过 brew 安装的软件去 /usr/local/opt 下找到对应的 .plist文件

```bash
sudo cp /usr/local/opt/nginx/*.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.nginx.plist

# 验证.plist文件
sudo plutil -lint /Library/LaunchDaemons/com.mysql.plist
# 注册系统服务
sudo launchctl load -w /Library/LaunchDaemons/*.plist
# 卸载注册服务
sudo launchctl unload -w /Library/LaunchDaemons/*.plist
# 修改执行权限
sudo chown root:wheel /Library/LaunchDaemons/*.plist
```

## 可参考配置
- https://github.com/mdo/config
- https://github.com/mzdr/macOS
- https://github.com/boochtek/mac_config
- https://github.com/bkuhlmann/mac_os-config
- https://github.com/kevinSuttle/macOS-Defaults
