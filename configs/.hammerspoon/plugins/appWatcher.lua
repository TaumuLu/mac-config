local safari = require 'plugins.safariWatcher'
local finder = require 'plugins.finderWatcher'

local watcher = {
  safari,
  finder
}

local prevApp
function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    local bundleID = appObject:bundleID()
    for k,v in ipairs(watcher) do
      local appId = v.id
      if appId == bundleID then
        v.enable()
      elseif appId == prevApp then
        v.disable()
      end
    end
    prevApp = bundleID
  end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
