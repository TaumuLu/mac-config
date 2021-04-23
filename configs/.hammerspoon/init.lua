-- package.path = package.path..";plugins/?.lua"
-- 引入公共模块，全局变量的方式使用
require 'plugins.common.index'

require 'plugins.autoReload'
require 'plugins.posMouse'
require 'plugins.stateCheck'
require 'plugins.resetLaunch'

require 'plugins.appWatch.index'
require 'plugins.caffWatch.index'

require 'plugins.hotkey'
