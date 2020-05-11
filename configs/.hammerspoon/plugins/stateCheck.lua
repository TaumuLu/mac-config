function checkAutoLaunch()
  local isLaunch = hs.autoLaunch()
  if (isLaunch == false) then
    hs.autoLaunch(true)
    hs.alert('hammerspoon is autoLaunch')
  end
end

function toggleConsole()
  hs.hotkey.bind({'cmd', 'option', 'shift'}, 'c', function()
    local state = hs.dockIcon()
    hs.dockIcon(not state)
  end)
end

checkAutoLaunch()
toggleConsole()
