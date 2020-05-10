# mac-config
在这组织我的mac配置，定义一些脚本方便快速重装、迁移、同步配置  
同时记录一些配置和技巧  

## 使用
直接执行init.sh脚本即可，install.sh脚本也可单独执行  

### 执行脚本
- init.sh
- install.sh

#### init.sh
初始化脚本，建立文件夹，克隆mac-config项目到指定目录，执行install.sh脚本  
无依赖直接使用方式  
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/TaumuLu/mac-config/master/init.sh)"`

#### install.sh
安装执行脚本，安装rvm、zsh，引入公共库并source install和script目录下的脚本  
执行init.sh时会自动执行，也可进入项目目录下执行  
`./install.sh`

## 脚本目录

### install
目录下的脚本依赖install.sh脚本调用，无法单独执行

- brew
  + 脚本中的变量brewList、brewCaskList定义了安装软件的列表
  + 安装所有brew及cask列表中的软件，会跳过已安装过的软件
  + 安装完成后执行brew services注册服务
  + 运行duti命令关联文件打开方式
  + 初始化操作，安装fzf等
- flutter
  + 安装flutter
- node
  + 安装node
  + npm install列表里的全局包
- vim
  + 安装spf13_vim

### script
一些脚本处理，包括bash公共工具库

- links.py
  + 需要python3环境，软链接dotfilts文件脚本，根目录下执即可，需要链接的地址可以自定义修改链接地址
  + 参数-i忽略已创建相同的链接文件
  + 参数-f强制创建链接覆盖目标文件/文件夹
- links.sh
  + 无依赖link脚本，简单的link必要文件配置
- mac-setting
  + [defaults-write](https://www.defaults-write.com)
  + defaults命令可以访问和修改Mac系统的默认设置
- open-url
  + 无法通过brew安装的软件，直接打开浏览器地址手动下载
- common
  + 公共函数库

## 配置目录
通过软链统一管理软件配置，链接了以下文件/文件夹

### dotfilts
- .bash_profile
- .bashrc
- .gitconfig
- .npmrc
- .vimrc
- .zshrc
- proxychains.conf

### configs
- .hammerspoon
- .SwitchHosts
- karabiner

#### hammerspoon
自动化工具，可以通过写lua脚本去实现想要的功能，目前写了以下脚本

- autoBluetooth
  + 屏幕锁定解锁自动开启/关闭蓝牙
  + 快捷键连接蓝牙设备，通过name变量定义要连接的设备名称
  + alt+l自动连接airpods，alt+shift+l自动断开
- autoReload
  + 修改脚本后自动加载hammerspoon
- posMouse
  + 多显示器快速切换定位鼠标
  + alt+`切换鼠标到下一显示器，并且定位在其屏幕中间，且触发点击聚焦屏幕
- stateCheck
  + 检查hammerspoon状态，提供快捷键显示/隐藏dock图标，方便调试
- safariScript
  + yuquePaste
    - 为safari中的语雀提供的脚本
    - 目的是粘贴文本时不带样式，同时保留统一url类型的粘贴样式
  + 同chrome的快捷键切换标签

#### karabiner
键盘改键软件，有多种方案配置，目前主要为将caps lock按键改为点按为esc，长按为control

#### duti
通过duti命令修改文件的默认打开方式，目前定义了sublime和vscode

## data目录
存储相关的脚本数据  

- data.js
  + SwitchHosts初始数据
- duti
  + duti配置数据
- tampermonkey
  + 油猴脚本代码

## 其他
- 如果当前shell为zsh，则不会加载bash相关文件，如需要加载，在.zshrc中写入source引用bash配置
- 如果追求零配置shell推荐使用fish

### 命令片段

#### 查看当前shell
```bash
echo $SHELL
ps -p $$
```

#### 清除DNS缓存
```
sudo killall -HUP mDNSResponder
sudo killall mDNSResponderHelper
sudo dscacheutil -flushcache
```

#### 列出app store安装的应用
```
find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'
```

### 保存iterm2配置
- 打开iTerm2时创建一个默认文件com.googlecode.iterm2.plist
- 删除iterm2的所有缓存首选项：defaults delete com.googlecode.iterm2
- 将文件复制到Preferences文件夹中，恢复旧的配置文件和设置
- 读取配置defaults read -app iTerm或运行defaults read com.googlecode.iterm2
- 或者killall cfprefsd
- 打开iTerm2

### QuickLook
[quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)

### 模拟慢速网络
xcode工具[Network Link Conditioner](https://www.jianshu.com/p/343aa3a65c5c)  
在Additional tools for Xcode目录下载  

### 快捷键
- control+shift+power 息屏，程序继续运行
- command+option+power 睡眠，等于合盖
- control+power 显示重启、关机、睡眠对话框
- command+control+power 重新启动

### 设置开机自启
利用Launchctl来设置，通过写在/Library/LaunchDaemons/下的.plist文件  
通过brew安装的软件去/usr/local/opt下找到对应的.plist文件  

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
