function Trim(text)
  return string.gsub(text, "[\t\n\r]+", "")
end

function ExecBlueutilCmd(params, noExec)
  local execCmd = "/usr/local/bin/blueutil "
  local cmd = "[ -x "..execCmd.." ] && "..execCmd..(params)
  if (noExec ~= nil) then
    return cmd
  end
  return Trim(hs.execute(cmd))
end

function FindDeviceId(keyword)
  return ExecBlueutilCmd("--recent | grep '"..keyword.."' | awk '{print $2}' | cut -d ',' -f 1")
end

local workWifi = {
  "bytedance",
  "Nanshan",
  "WIFI-"
}

function IsWorkEnv()
  local ssid = hs.wifi.currentNetwork()
  local flag = false
  if ssid then
    for _, value in pairs(workWifi) do
      if string.find(ssid:lower(), value:lower()) then
        flag = true
        break
      end
    end
  end
  return flag
end
