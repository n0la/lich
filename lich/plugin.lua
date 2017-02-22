-- Plugin template for lich
--

local plugin = {}

function plugin:new()
   local neu = {}

   setmetatable(neu, self)
   self.__index = self

   return neu
end

function plugin:onmessage(server, user, channel, msg)
end

function plugin:onconnect(server)
end

function plugin:oncommand(server, user, channel, cmd)
end

return plugin
