local io = { popen = io.popen }
local helpers = require"vicious.helpers"
local spawn = require("vicious.spawn")

return helpers.setasyncall{
  async = function (format, warg, callback)
    local cmd = "xbacklight -get"
    spawn.easy_async_with_shell(
      cmd,
      function (std_out, std_err, exit_reason, exit_code)
        local ret = math.floor(tonumber(std_out))
        callback({ ret })
      end)
  end }

