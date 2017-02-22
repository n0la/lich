-- Log module for LICH
--

local log = {}

local io = require('io')

log.VERBOSE = false
log.DEBUG = false

log.INFO = true
log.ERROR = true

function log.verbose(msg)
   if log.VERBOSE or log.DEBUG then
      io.stdout:write('dbg: ' .. msg .. "\n")
   end
end

log.debug = log.verbose

function log.info(msg)
   if log.INFO then
      io.stdout:write('inf: ' .. msg .. "\n")
   end
end

function log.error(msg)
   if log.ERROR then
      io.stderr:write('err: ' .. msg .. "\n")
   end
end

return log
