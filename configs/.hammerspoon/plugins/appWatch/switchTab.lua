local finder = require 'plugins.appWatch.finderApp'

local switchTabLeft = hs.hotkey.new({'alt', 'cmd'}, 'left', function()
  hs.eventtap.keyStroke({'cmd','shift'}, '[')
end)
local switchTabRight = hs.hotkey.new({'alt', 'cmd'}, 'right', function()
  hs.eventtap.keyStroke({'cmd','shift'}, ']')
end)

return {
  id = {
    'com.apple.Safari',
    finder.id
  },
  enable= function()
    switchTabLeft:enable()
    switchTabRight:enable()
  end,
  disable = function()
    switchTabLeft:disable()
    switchTabRight:disable()
  end
}
