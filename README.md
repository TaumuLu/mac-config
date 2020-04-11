# mac-config
在这组织我的mac配置，定义一些脚本方便快速重装、迁移、同步配置  
同时记录一些配置和技巧  

## 使用
目前的使用方式很乱，脚本都写好了，需要整理分类使用  

### 执行脚本
- init.sh
- install.sh

#### init.sh
初始化安装脚本，下载brew、zsh，并且安装所有brew及cask列表中的软件，跳过已安装软件  
无依赖直接使用方式  
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/TaumuLu/mac-config/master/init.sh)"`

#### install.sh
安装非brew软件flutter、vim配置等，并且link dotfilts文件，如果执行了init.sh，会自动执行  
进入项目目录下执行  
`./install.sh`

## brew
init.sh脚本中的变量brewList、brewCaskList定义了安装软件的列表

## dotfilts
dotfilts可以统一管理软件配置，基于需要自己写了脚本用来同步，目前链接了一下文件/文件夹

### file
- .bash_profile
- .bashrc
- .gitconfig
- .npmrc
- .vimrc
- .zshrc

### folder
- .hammerspoon
- karabiner

## 脚本文件

### links.py
需要python3环境，软链接dotfilts文件脚本，根目录下执即可，需要链接的地址可以自定义修改链接地址

### mac-setting.sh
defaults命令可以访问和修改Mac系统的默认设置  
- [defaults-write](https://www.defaults-write.com)

### open-url.sh
无法通过brew安装的软件，直接打开浏览器地址手动下载  

## configs

### hammerspoon
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
- yuquePaste
  + 为safari中的语雀提供的脚本
  + 目的是粘贴文本时不带样式，同时保留统一url类型的粘贴样式

### karabiner
键盘改键软件，有多种方案配置，目前主要为将caps lock按键改为点按为esc，长按为control

### duti
通过duti命令修改文件的默认打开方式，目前定义了sublime和vscode

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
