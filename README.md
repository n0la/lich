lich - Lua IRC Connector and Helper is an IRC bot framework written in Lua

## Overview

LICH is a Lua based IRC bot that can handle plugins written in LUA. It
aims to ship a few standard plugins, as an example on how to roll your
own.

## Configuration

The configuration file format is YAML and looks like this:

```yaml
servers:
  freenode:
    nick: lich
    url: irc.freenode.net
    plugins:
      - name: lua.package.path.to.plugin
        config1: first config option
        config2: second config option
      - name: another.lua.plugin
        config1: first config option
    channels:
      - name: "##mychannel"
```

## Requirements

* Lua 5.3
* My own fork of [LuaIRC](https://github.com/n0la/LuaIRC)
* [lyaml](https://github.com/gvvaughan/lyaml)
* [cliargs](https://github.com/amireh/lua_cliargs)

## Plugins

### Writing new ones

Your plugin file needs to provide a table that is capable of spawning
a new plugin when calling ```new```. This table should, for the sake of
simplicity, inherit from the ```plugin``` object provided by lich:

```lua
local plugin = require('lich.plugin')
local myplugin = plugin:new()

function myplugin:new(config)
    local neu = plugin:new(config)

    setmetatable(neu, self)
    self.__index = self

    return neu
end

return myplugin
```

And here is the interface:

```lua
-- Must return the fully qualified package name of the plugin
function myplugin:name()
end

-- Is called when connection to a server has been established
--   server  .. Reference to the LuaIRC server table
function myplugin:onconnect(server)
end

-- Is called when a message has been received
--   server  .. Reference to the LuaIRC server table
--   user    .. Reference to the LuaIRC user table
--   channel .. Channel name
--   msg     .. Message as string
function myplugin:onmessage(server, user, channel, msg)
end

-- Is called when the message parses as command (starts with a #).
-- This method is called after onmessage().
--   server  .. Reference to the LuaIRC server table
--   user    .. Reference to the LuaIRC user table
--   channel .. Channel name
--   cmd     .. Reference to the LICH command object
function myplugin:oncommand(server, user, channel, cmd)
end
```

### freenode_registrar

The plugin ```freenode_registrar``` allows you to register the bot
with the nickserv as provided by freenode:

```
plugins:
  - name: lich.plugin.freenode_registrar
    password: supersecret
```
