#!/usr/bin/env bash

# 预先要求管理员密码
sudo -v

###############################################################################
# init mac                                                                    #
###############################################################################
isInit=`defaults read com.apple.finder AppleShowAllFiles || echo 0`
if [ $isInit -eq 0 ]; then
  # 取消4位数密码限制
  pwpolicy -clearaccountpolicies
  # 修改密码
  passwd
  # 清除dock所有应用程序的图标
  defaults write com.apple.dock persistent-apps -array
  defaults delete com.apple.dock persistent-others
fi

# Enable apps at startup
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Hammerspoon.app", hidden:true}' > /dev/null
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Karabiner-Elements.app", hidden:true}' > /dev/null

# dock 设置
# 根据用户最近的使用自动重排
defaults write com.apple.dock mru-spaces -bool true
# 显示最近
defaults write com.apple.dock show-recents -bool false
# 弹跳打开程序图标
defaults write com.apple.dock no-bouncing -bool true
# 设置 dock 大小
defaults write com.apple.dock tilesize -int 60
# 放大
defaults write com.apple.dock magnification -bool true
# 设置放大尺寸大小
defaults write com.apple.dock largesize -int 110
# 锁定 dock
defaults write com.apple.Dock size-immutable -bool yes
# 自动隐藏
defaults write com.apple.dock autohide -bool false

# 设置命令
# 安全设置显示任何来源选项
sudo spctl --master-disable
# 关闭确定要打开应用弹框
defaults write com.apple.LaunchServices LSQuarantine -bool false

# 取消开盖启动
# sudo nvram AutoBoot=%00
# 恢复开盖启动
# sudo nvram AutoBoot=%03
# 开启开机音效
# sudo nvram BootAudio=%01
# 取消开机音效
# sudo nvram BootAudio=%00

# defaults
# NSGlobalDomain
# 显示文件扩展名
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# 默认保存到磁盘，不保存到iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# 关闭自动大写
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# 所有控件启用完全的键盘访问
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# 禁止自动拼写纠正
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Safari
# 显示Safari调试菜单
defaults write com.apple.Safari IncludeDebugMenu -bool true
# 默认隐藏Safari的书签栏
defaults write com.apple.Safari ShowFavoritesBar -bool false
# 启用S​​afari的调试菜单
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
# 在Safari中启用“开发”菜单和Web检查器
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# 显示Xcode每一次build的所用时间
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true

# 隐藏DashBoard
defaults write com.apple.dashboard mcx-disabled -bool true

# 更改截图位置
defaults write com.apple.screencapture location ~/Downloads

# 禁止在网络驱动器上生成 .DS_Store 文件
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# openemu获得音频设备
defaults write org.openemu.OpenEmu HUDBarShowAudioOutput -bool YES

# 30分钟显示器休眠
# sudo pmset -a displaysleep 15

# 显示隐藏文件
defaults write com.apple.finder AppleShowAllFiles -bool true
# 按名称排序，文件夹在最前面
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# 搜索时默认搜索当前文件夹
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# 关闭更改扩展名警告
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# 视图查看模式
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"
# Finder 显示状态栏
defaults write com.apple.finder ShowStatusBar -bool true
# Finder 显示地址栏
defaults write com.apple.finder ShowPathbar -bool true
# defaults write com.apple.finder NSQuitAlwaysKeepsWindows -bool true

# 电池电量显示百分比
defaults write com.apple.menuextra.battery ShowPercent -bool true

# dock
# 不显示最近打开的应用
defaults write com.apple.dock show-recents -bool false
# 重置launchpod
defaults write com.apple.dock ResetLaunchPad -bool true

# 状态栏菜单展示图标
defaults write com.apple.systemuiserver menuExtras -array\
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"\
  "/System/Library/CoreServices/Menu Extras/AirPort.menu"\
  "/System/Library/CoreServices/Menu Extras/Battery.menu"\
  "/System/Library/CoreServices/Menu Extras/Clock.menu"\
  "/System/Library/CoreServices/Menu Extras/Volume.menu"\
  # "/System/Library/CoreServices/Menu Extras/RemoteDesktop.menu"\
  # "/System/Library/CoreServices/Menu Extras/Script Menu.menu"\
  # "/System/Library/CoreServices/Menu Extras/TextInput.menu"\
  # "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"\

# Chrome
# 前进后退手势
# 触控板
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool true
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool true
# 鼠标
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

# 关闭黑暗模式
defaults write com.tencent.qq NSRequiresAquaSystemAppearance -bool true
defaults write com.irradiatedsoftware.SizeUp NSRequiresAquaSystemAppearance -bool true
defaults write com.fiplab.batteryairpods NSRequiresAquaSystemAppearance -bool true
defaults write com.tencent.xinWeChat NSRequiresAquaSystemAppearance -bool true

# 关闭镜像验证
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Terminal使用UTF-8
defaults write com.apple.terminal StringEncodings -array 4

###############################################################################
# record                                                                      #
###############################################################################

# # 桌面只显示一个应用
# defaults write com.apple.dock single-app -bool true
# # 更改截屏文件存储格式
# defaults write com.apple.screencapture type png
# # 桌面只显示已打开的应用
# defaults write com.apple.dock static-only -boolean true
# # 主题设置黑暗模式，只让菜单栏和 Dock栏变为深色模式
# defaults write -g NSRequiresAquaSystemAppearance -bool true

# 重启命令
killall Dock
killall Finder
killall SystemUIServer
# killall Safari
# killall cfprefsd

# appList=(
#   "Activity Monitor"
#   "Address Book"
#   "Calendar"
#   "Contacts"
#   "cfprefsd"
#   "Dock"
#   "Finder"
#   "Mail"
#   "Messages"
#   "Safari"
#   "SystemUIServer"
#   "Terminal"
#   "iCal"
# )
# IFS=""

# for app in ${appList[*]}; do
#   killall "${app}" > /dev/null 2>&1
# done

# 息屏时间
# 音量蓝牙等图标展示
