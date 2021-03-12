local watchPath = "/Applications"

local function checkFileExist(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

local function reloadApp(paths, flagTables)
  local isChange = false
  for _, file in pairs(paths) do
    local count = 0

    for _ in file:gmatch("/") do
      count = count + 1
    end

    local isApp = file:sub(-4) == ".app"
    if count == 2 and isApp then
      local text = checkFileExist(file) and '安装' or '卸载'
      hs.alert.show(text..": "..file)
      isChange = true
      break
    end
  end

  if isChange == true then
    hs.alert.show("app change")
    -- print(hs.inspect.inspect(paths))

    hs.execute("defaults write com.apple.dock ResetLaunchPad -bool true")
    hs.execute("killall Dock")
  end
end

local timer = nil
AppChangeWatcher = hs.pathwatcher.new(watchPath, function (paths, flagTables)
  if timer then
    timer:stop()
    timer = nil
  end
  timer = hs.timer.doAfter(5, function()
    reloadApp(paths, flagTables)
  end)
end)
AppChangeWatcher:start()
