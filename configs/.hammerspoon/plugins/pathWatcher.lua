local function reloadApp(paths)
  local isChange = false
  for _,file in pairs(paths) do
    local count = 0
    local value = file:find(".DS_Store")

    if value == nil then
      for w in file:gmatch("/") do
        count = count + 1
      end
      if count == 2 then
        isChange = true
        break
      end
    end
  end

  if isChange == true then
    hs.execute("defaults write com.apple.dock ResetLaunchPad -bool true")
    hs.execute("killall Dock")
    hs.alert.show("app change")
  end
end

appChangeWatcher = hs.pathwatcher.new("/Applications", reloadApp)
appChangeWatcher:start()
