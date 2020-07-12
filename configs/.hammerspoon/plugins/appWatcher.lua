local safari = require 'plugins.safariWatcher'
local finder = require 'plugins.finderWatcher'

local switchTabLeft = hs.hotkey.new({'alt', 'cmd'}, 'left', function()
  hs.eventtap.keyStroke({'cmd','shift'}, '[')
end)
local switchTabRight = hs.hotkey.new({'alt', 'cmd'}, 'right', function()
  hs.eventtap.keyStroke({'cmd','shift'}, ']')
end)

local switchApps = {
  id = {
    safari.id,
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

local watcher = {
  safari,
  switchApps
}


local function trigger(object, name)
  if object[name] ~= nil then
    object[name]()
  end
end

local function hasValue(appIds, value)
    if type(appIds) ~= 'table' then
      return appIds == value
    end

    local flag = false
    for _, v in ipairs(appIds) do
      if v == value then
        flag = true
        break;
      end
    end
    return flag
end

local prevApp
local function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    local bundleID = appObject:bundleID()
    for _, v in ipairs(watcher) do
      local appIds = v.id

      if hasValue(appIds, bundleID) then
        trigger(v, 'enable')
      elseif hasValue(appIds, prevApp) then
        trigger(v, 'disable')
      end
    end
    prevApp = bundleID
  end
end

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
