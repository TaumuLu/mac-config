function getExecBlueutilCmd(params, isExec)
  local execCmd = "/usr/local/bin/blueutil "
  local cmd = "[ -x "..execCmd.." ] && "..execCmd..(params)
  if (isExec ~= nil) then
    return hs.execute(cmd)
  end
  return cmd
end

function bluetoothSwitch(state)
  getExecBlueutilCmd("--power "..(state), true)
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



local name = "Taumu的AirPods"

function trim(text)
  return string.gsub(text, "[\t\n\r]+", "")
end

function searchDevice(callback, value)
  local id = trim(getExecBlueutilCmd("--recent | grep '"..name.."' | awk '{print $2}' | cut -d ',' -f 1", true))
  if (string.len(id) > 0) then
    local isConnected = trim(getExecBlueutilCmd("--is-connected "..id, true))
    if (isConnected == value) then
      callback(id)
    end
  end
end

local hyper = {'alt'}
hs.hotkey.bind(hyper, 'l', function()
  searchDevice(function(id)
    getExecBlueutilCmd("--connect "..id, true)
  end, "0")
end)

local hyper = {'alt', 'shift'}
hs.hotkey.bind(hyper, 'l', function()
  searchDevice(function(id)
    getExecBlueutilCmd("--disconnect "..id, true)
  end, "1")
end)
