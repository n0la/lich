-- Registrar plugin
--

local registrar = {}

function registrar:new(conf)
   local neu = {}

   setmetatable(neu, self)
   neu.__index = self

   assert(conf.name, 'registrar: no name for registrar set')
   assert(conf.password, 'registrar: no password for registrar set')

   self.config = conf
   self.server = conf.server
   self.parent = conf.lich

   return neu
end

return registrar
