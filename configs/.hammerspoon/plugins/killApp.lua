local function killApp(appId)
  local apps = hs.application.applicationsForBundleID(appId)
  for _, app in ipairs(apps) do
    app:kill()
    if app:isRunning() then
      app:kill9()
    end
  end
  print("kill "..appId)
end

local function caffeinateCallback(eventType)
  if (eventType == hs.caffeinate.watcher.screensDidSleep) then
    print("screensDidSleep")
    killApp("com.apple.iphonesimulator")
  elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
    print("screensDidWake")
  elseif (eventType == hs.caffeinate.watcher.screensDidLock) then
    print("screensDidLock")
  elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
    print("screensDidUnlock")
  end
end

local caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()
