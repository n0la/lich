-- A freenode registrar plugin
--

local plugin = require('lich.plugin')
local freenode_registrar = plugin:new()

local log = require('lich.log')

function freenode_registrar:new(config)
   local neu = plugin:new()

   setmetatable(neu, self)
   self.__index = self

   self.config = config or {}

   assert(self.config.password, 'freenode_registrar: no password specified')

   return neu
end

function freenode_registrar:name()
   return 'lich.plugin.freenode_registrar'
end

function freenode_registrar:onconnect(server)
   -- Upon connecting send the password to nickserv
   log.info('freenode_registrar: sending login information to nickserv')
   server.socket:sendChat('NickServ', 'identify ' .. self.config.password)
end

function freenode_registrar:onmessage(server, user, channel, msg)
   if string.lower(user.nick) == 'nickserv' then
      log.info('freenode_registrar: answer from nickserv: ' .. msg)
   end
end

return freenode_registrar
