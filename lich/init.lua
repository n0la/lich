-- LICH main module
--

local base = _G

local log = require('lich.log')

local lyaml = require('lyaml')
local io = require('io')

local irc = require('irc')
irc.set = require('irc.set')

local server = require('lich.server')

local lich = {}

function lich:new(conf)
   local neu = {}

   setmetatable(neu, self)
   self.__index = self

   if type(conf) == 'string' then
      neu:_load_config(conf)
   elseif type(conf) == 'table' then
      neu._config = conf
   end

   neu.servers = {}
   neu.set = irc.set.new({timeout = 1})

   assert(neu._config.servers, 'lich: no servers specified')

   for name, i in base.pairs(neu._config.servers) do
      i.name = name

      local sr = server:new(neu, i)
      neu.set:add(sr.socket)
      table.insert(neu.servers, sr)
   end

   return neu
end

function lich:_load_config(file)
   local file = io.open(file, 'r')
   if not file then
      error('lich: could not load configuration file: ' .. file)
   end

   local content = file:read('*all')
   file:close()

   self._config = lyaml.load(content)
end

function lich:_onmessage(server, user, channel, msg)
   -- iterate over plugins and tell them what happened
end

function lich:run()
   self._stop = false

   while not self._stop do
      local ready = self.set:poll()

      if ready then
         for _, server in base.ipairs(self.servers) do
            server:think()
         end
      end
   end
end

function lich:stop()
   self._stop = true
end

return lich
