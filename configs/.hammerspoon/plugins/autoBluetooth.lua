function bluetoothSwitch(state)
  execCmd = "/usr/local/bin/blueutil"
  cmd = "[ -x "..execCmd.." ] && "..execCmd.." --power "..(state)
  result = hs.execute(cmd)
end

function caffeinateCallback(eventType)
  if (eventType == hs.caffeinate.watcher.screensDidSleep) then
    print("screensDidSleep")
  elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
    print("screensDidWake")
  elseif (eventType == hs.caffeinate.watcher.screensDidLock) then
    print("screensDidLock")
    bluetoothSwitch(0)
  elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
    print("screensDidUnlock")
    bluetoothSwitch(1)
  end
end

caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()
