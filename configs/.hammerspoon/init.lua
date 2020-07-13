require 'plugins.autoReload'
require 'plugins.appWatcher'
require 'plugins.caffeinateWatcher'
require 'plugins.posMouse'
require 'plugins.stateCheck'
require 'plugins.resetLaunch'

-- 调试代码
hs.hotkey.bind({'cmd', 'option', 'shift'}, 'h', function()
  hs.alert('Hello World from Hammerspoon')
  -- speaker = hs.speech.new()
  -- speaker:speak("Hammerspoon is online")
  -- hs.notify.new({title="Hammerspoon launch", informativeText="Boss, at your service"}):send()
end)
