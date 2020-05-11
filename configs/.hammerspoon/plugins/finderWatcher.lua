local appId = 'com.apple.finder'

local keyList = {
  hs.keycodes.map.shift,
  hs.keycodes.map.ctrl,
  hs.keycodes.map.tab
}

function postKeyEvent(...)
  local args={...}
  return function()
    for i=1, #keyList do
      local key = keyList[i]
      local isdown = args[i]
      if isdown == nil then
        isdown = true
      end
      hs.eventtap.event.newKeyEvent(key, isdown):post(appId)
    end
  end
end

local switchTabLeft = hs.hotkey.new({'alt', 'cmd'}, 'left', postKeyEvent(true))
local switchTabRight = hs.hotkey.new({'alt', 'cmd'}, 'right', postKeyEvent(false))

return {
  id = appId,
  enable = function()
    switchTabLeft:enable()
    switchTabRight:enable()
  end,
  disable = function()
    switchTabLeft:disable()
    switchTabRight:disable()
  end
}