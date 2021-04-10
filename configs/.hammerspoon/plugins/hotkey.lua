-- 调试代码
hs.hotkey.bind({'cmd', 'option', 'shift'}, 'h', function()
  hs.alert('Hello World from Hammerspoon')
  -- speaker = hs.speech.new()
  -- speaker:speak("Hammerspoon is online")
  -- hs.notify.new({title="Hammerspoon launch", informativeText="Boss, at your service"}):send()
end)

-- 快捷键锁屏，对齐 win 的快捷键
hs.hotkey.bind({'cmd'}, 'l', function()
  hs.caffeinate.lockScreen()
end)

-- 隐藏当前 app，有些 app 没有绑定此快捷键，大部分 app 有此功能
hs.hotkey.bind({'cmd'}, 'h', function ()
  local apps = hs.application.frontmostApplication()
  apps:hide()
end)
