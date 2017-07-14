-- Plugin loader
--

local plugins = {}
local base = _G

local log = require('lich.log')

function plugins:new()
   local neu = {}

   setmetatable(neu, self)
   self.__index = self

   neu.loaded = {}

   return neu
end

function plugins:load(config)
   assert(config, 'lich: no plugin configuration')

   for _, plugin in base.pairs(config) do
      local fullname = plugin.name

      assert(fullname, 'lich: plugin has no name')

      local ok, pl = pcall(require, fullname)
      if not ok then
         log.error('failed to load plugin: ' .. fullname .. ': ' .. pl)
      else
         log.info('loaded plugin ' .. fullname)
         local plug = pl:new(plugin)
         table.insert(self.loaded, plug)
      end
   end
end

function plugins:fire(method, ...)
   for _, plugin in base.pairs(self.loaded) do
      local func = plugin[method]
      if not func or type(func) ~= 'function' then
         log.debug('plugin ' .. plugin:name() ..
                      ' does not support method ' .. method)
      else
         func(plugin, ...)
      end
   end
end

function plugins:onconnect(server)
   return self:fire('onconnect', server)
end

function plugins:onmessage(server, user, channel, msg)
   return self:fire('onmessage', server, user, channel, msg)
end

function plugins:oncommand(server, user, channel, cmd)
   return self:fire('oncommand', server, user, channel, cmd)
end

return plugins
