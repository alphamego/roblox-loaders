--[[
  Scriptos — Atlanta UI loader
  Purple dock-style UI with blur, configs, theme editor, Drawing support.
  Menu toggle: Insert (default in built-in settings)
]]

print("[Atlanta] loader start")
repeat task.wait() until game:IsLoaded()

local GH = "https://raw.githubusercontent.com/alphamego/roblox-loaders/main/scriptos/atlanta"
local BASE = getgenv().SCRIPTOS_ATLANTA_URL or GH

getgenv().cloneref = getgenv().cloneref or function(o) return o end
getgenv().gethui = getgenv().gethui or function()
	return game:GetService("CoreGui")
end

local loadstring = loadstring or load
if not loadstring then
	error("[Atlanta] loadstring missing")
end

local required = { "makefolder", "writefile", "readfile", "isfile", "getcustomasset", "delfile", "listfiles" }
for _, name in ipairs(required) do
	if not getgenv()[name] and not _G[name] then
		error("[Atlanta] missing executor API: " .. name)
	end
end

if not (Drawing and Drawing.new) then
	error("[Atlanta] Drawing API missing")
end

local function httpGet(url)
	if game.HttpGet then
		return game:HttpGet(url, true)
	end
	if syn and syn.request then
		return syn.request({ Url = url, Method = "GET" }).Body
	end
	if request then
		return request({ Url = url, Method = "GET" }).Body
	end
	error("[Atlanta] no HttpGet/request")
end

local function loadFromSource(label, src)
	if not src or #src < 1000 then
		error(label .. " empty")
	end
	local fn, err = loadstring(src)
	if not fn then
		error(label .. " compile: " .. tostring(err))
	end
	local ok, a, b = pcall(fn)
	if not ok then
		error(label .. " runtime: " .. tostring(a))
	end
	return a, b
end

local function tryLocal()
	if not isfile then
		return nil
	end
	for _, path in ipairs({ "scriptos/atlanta/Library.lua", "Atlanta/Library.lua", "Library.lua" }) do
		if isfile(path) then
			print("[Atlanta] local:", path)
			return loadFromSource(path, readfile(path))
		end
	end
	return nil
end

local library, themes = tryLocal()
if not library then
	print("[Atlanta] fetching:", BASE .. "/Library.lua")
	library, themes = loadFromSource("Atlanta", httpGet(BASE .. "/Library.lua"))
end

if not library or not library.window then
	error("[Atlanta] library invalid")
end

getgenv().library = library
getgenv().Atlanta = library
getgenv().AtlantaThemes = themes

local window = library:window({ name = "Atlanta" })
local tab = window:tab({ name = "Main" })
local column = tab:column()
local section = column:section({ name = "Demo" })
section:label({ name = "Atlanta loaded (Scriptos)" })
section:toggle({ name = "Example toggle", flag = "atlanta_example", default = false })

window.set_menu_visibility(true)
library:notification({ text = "Atlanta loaded", time = 3 })
print("[Atlanta] ok — toggle menu: Insert")
