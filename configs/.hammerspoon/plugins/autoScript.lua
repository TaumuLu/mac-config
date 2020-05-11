local cmdArr = {
  "cd /Users/kaboom/Documents/book && source autopush.sh "
}

function shell(cmd)
  result = hs.osascript.applescript(string.format('do shell script "%s"', cmd))
end

function runAutoScripts()
  for key, cmd in ipairs(cmdArr) do
    shell(cmd)
  end
end

hs.timer.doEvery(3600, runAutoScripts)