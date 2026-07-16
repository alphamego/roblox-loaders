--[[
  LinoriaModded loader — black/purple Linoria fork.
  Menu toggle: RightControl / RightShift
]]

loadstring(game:HttpGet(
	(typeof(getgenv) == "function" and getgenv().LINORIAMODDED_DEMO_URL)
		or ("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/linoriamodded_demo.lua?v=20260716d")
))()
