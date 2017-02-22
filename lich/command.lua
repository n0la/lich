-- Simple command parser
--

local command = {}
local base = _G

function command:new()
   local neu = {}

   setmetatable(neu, self)
   self.__index = self

   return neu
end

function command:parse(str)
   local inquote = false
   local incommand = true
   local s = str

   local command = ''
   local arg = ''
   local args = {}

   if string.sub(s, 1, 1) ~= '#' then
      error('command does not start with a #')
   end

   s = string.sub(s, 2)
   if not s or s == "" then
      error('no command given')
   end

   for c in string.gmatch(s, '.') do
      if string.match(c, '%s') then
         if incommand then
            incommand = false
         elseif not incommand then
            if not inquote then
               table.insert(args, arg)
               arg = ''
            else
               arg = arg .. c
            end
         end

         hadescape = false
      elseif c == '\\' then
         hadescape = true
      elseif c == '"' then
         if incommand then
            error('special characters not allowed in command')
         end

         if hadescape then
            arg = arg .. c
         else
            inquote = not inquote
         end

         hadescape = false
      elseif incommand then
         hadescape = false
         command = command .. c
      elseif not incommand then
         hadescape = false
         arg = arg .. c
      end
   end

   if arg ~= '' then
      table.insert(args, arg)
   end

   if not command or command == "" then
      error('no command given')
   end

   self.command = command
   self.args = args
   self.message = str
end

return command
