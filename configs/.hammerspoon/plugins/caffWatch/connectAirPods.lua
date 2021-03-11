local function trim(text)
  return string.gsub(text, "[\t\n\r]+", "")
end

function ExecBlueutilCmd(params, noExec)
  local execCmd = "/usr/local/bin/blueutil "
  local cmd = "[ -x "..execCmd.." ] && "..execCmd..(params)
  if (noExec ~= nil) then
    return cmd
  end
  return trim(hs.execute(cmd))
end

function FindDeviceId(keyword)
  return ExecBlueutilCmd("--recent | grep '"..keyword.."' | awk '{print $2}' | cut -d ',' -f 1")
end

local function bluetoothSwitch(state)
  ExecBlueutilCmd("--power "..(state))
end

local function searchDevice(callback, value, deviceName)
  local id = FindDeviceId(deviceName)
  if (string.len(id) > 0) then
    local isConnected = ExecBlueutilCmd("--is-connected "..id)
    if (isConnected == value) then
      callback(id)
    end
  end
end


local name = "Taumu的AirPods"

local function handleDevice(connect)
  local param = "--connect"
  local value = "0"
  if connect == false then
    param = "--disconnect"
    value = "1"
  end

  return function ()
    searchDevice(function(id)
      if connect == true then
        hs.execute('osascript -e "set volume output muted 0"')
      end
      ExecBlueutilCmd(param.." "..id)
    end, value, name)
  end
end

local connectDevice = handleDevice()
local disconnectDevice = handleDevice(false)

local hyper = {'alt'}
hs.hotkey.bind(hyper, 'l', connectDevice)

local hyper = {'alt', 'shift'}
hs.hotkey.bind(hyper, 'l', disconnectDevice)

return {
  screensDidLock = function ()
    bluetoothSwitch(0)
  end,
  screensDidUnlock = function ()
    bluetoothSwitch(1)
    local timer
    timer = hs.timer.doEvery(1, function ()
      if ExecBlueutilCmd("--power") == "1" then
        timer:stop()
        connectDevice()
      end
    end)
  end
}
