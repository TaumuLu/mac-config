local autoBluetooth = require 'plugins.autoBluetooth'
local killApp = require 'plugins.killApp'

local watcher = {
  autoBluetooth,
  killApp
}

local function findKey(eventType)
  local name
  for key, value in pairs(hs.caffeinate.watcher) do
    if value == eventType then
      name = key
      break
    end
  end
  return name
end

local function caffeinateCallback(eventType)
  local key = findKey(eventType)
  print(key)

  for eventName, value in pairs(watcher) do
    local event = value[key]
    if event ~= nil then
        print(eventName)
        event()
    end
  end
end

CaffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
CaffeinateWatcher:start()
