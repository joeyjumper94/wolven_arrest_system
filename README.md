# wolven_arrest_system

this addon is to make arresting more realistic, more rewarding for cops, and more punishing to get arrested as well as discourage going AFK while arrested

pretty much all the configuration that needs to be done can be done by editing lua/autorun/wolvent_arrest_system.lua

there are also some changes that need to be made to the darkrp settings

darkrpmodification/lua/darkrp_config/settings.lua change GM.Config.jailtimer to 3600 we want it to be long enough that they try to bust themselves out, pay bail, or have someone else bust them out

darkrpmodification/lua/darkrp_config/settings.lua change GM.Config.telefromjail to false, we don't want them to always go to spawn then they are unarrested.

darkrpmodification/lua/darkrp_launguage/englist.lua change youre_arrested to something like "You have been arrested. Time left till min bail: %d seconds!"
