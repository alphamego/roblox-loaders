--[[
  LinoriaModded loader — black/purple Linoria fork with Plex font + optional ghost drag.
  Menu toggle: RightControl / RightShift
]]

loadstring(game:HttpGet(
	(typeof(getgenv) == "function" and getgenv().LINORIAMODDED_DEMO_URL)
		or "https://raw.githubusercontent.com/alphamego/roblox-loaders/main/linoriamodded_demo.lua"
))()
