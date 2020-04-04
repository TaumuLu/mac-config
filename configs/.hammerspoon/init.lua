require 'plugins.autoReload'
require 'plugins.posMouse'
require 'plugins.yuquePaste'

-- 调试代码
hs.hotkey.bind({'cmd', 'shift'}, 'h', function()
  hs.alert('Hello World from Hammerspoon')
  -- speaker = hs.speech.new()
  -- speaker:speak("Hammerspoon is online")
  -- hs.notify.new({title="Hammerspoon launch", informativeText="Boss, at your service"}):send()
end)
