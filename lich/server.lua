-- One IRC server we take care of
--

local server = {}

local base = _G

local irc = require('irc')
local log = require('lich.log')
local plugins = require('lich.plugins')
local command = require('lich.command')

function server:new(parent, conf)
   local neu = {}

   setmetatable(neu, self)
   self.__index = self

   assert(conf.name, 'lich: no name for server')
   assert(conf.nick, 'lich: no nick for server')
   assert(conf.url, 'lich: no url for server')

   neu.name = conf.name
   neu.nick = conf.nick
   neu.url = conf.url
   neu.parent = parent

   neu.conf = conf

   neu.channels = {}
   neu.socket = irc.new({nick = neu.nick})

   -- Connect to server
   log.info('connecting to: ' .. conf.name)
   neu.socket:connect(neu.url)

   if conf.channels then
      for _, obj in base.pairs(conf.channels) do
         assert(obj.name, 'lich: no channel name set')

         log.info('joining ' .. obj.name .. ' on ' .. conf.name)
         neu.socket:join(obj.name)
         table.insert(neu.channels, {name = obj.name})
      end
   end

   -- Load all plugins
   neu.plugins = plugins:new()
   if not neu.conf.plugins then
      log.info('no plugins specified for ' .. neu.name)
   else
      neu.plugins:load(neu.conf.plugins)
   end

   neu.socket:hook('OnChat', function(user, channel, msg)
                      neu:_onmessage(user, channel, msg)
   end)

   -- Send all plugins that we are connected
   neu.plugins:onconnect(neu)

   return neu
end

function server:_onmessage(user, channel, msg)
   self.plugins:onmessage(self, user, channel, msg)
   -- Check to see if the message can be parsed as command
   local c = command:new()
   local ok, cmd = pcall(c.parse, c, msg)

   if not ok then
      log.error('not a command: "' .. msg .. '": ' .. args)
   else
      self.plugins:oncommand(self, user, channel, cmd)
   end
end

function server:think()
   self.socket:think()
end

return server
