# mac-config
在这组织我的mac配置，定义一些脚本方便快速重装、迁移、同步配置  
同时记录一些配置和技巧，以及app  

## 使用
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/TaumuLu/mac-config/master/init.sh)"`

## 配置清单

## 技巧
- 如果当前shell为zsh，则不会加载bash相关文件，如需要加载，在.zshrc中写入source引用bahs配置

### defaults命令
defaults命令可以访问和修改Mac系统的默认设置  
- [defaults-write](https://www.defaults-write.com)

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

### 命令片段
```bash
# 查看当前shell
echo $SHELL
ps -p $$

# 列出app store安装的应用
find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'

# 清除DNS缓存
sudo killall -HUP mDNSResponder
sudo killall mDNSResponderHelper
sudo dscacheutil -flushcache
```

### 保存iterm2配置
- 打开iTerm2时创建一个默认文件com.googlecode.iterm2.plist
- 删除iterm2的所有缓存首选项：defaults delete com.googlecode.iterm2
- 将文件复制到Preferences文件夹中，恢复旧的配置文件和设置
- 读取配置defaults read -app iTerm或运行defaults read com.googlecode.iterm2
- 或者killall cfprefsd
- 打开iTerm2

## app清单
- InsomniaX 禁用Mac上的合盖休眠或闲置睡眠
- HazeOver 专注于当前app，置灰其他应用

### 模拟慢速网络
xcode工具[Network Link Conditioner](https://www.jianshu.com/p/343aa3a65c5c)  
在Additional tools for Xcode目录下载  

### QuickLook
[quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)

### 抓包工具
- shadowrocket
- HTTP Catcher
- Thor
- Charles

### 分屏软件
- sizeUp
- Moom
- Spectacle

### 快速调用程序
- Manico
- Contexts

### 工具
- Alfred
- Bettertouch
- Hammerspoon

### 编辑器
- reactide
