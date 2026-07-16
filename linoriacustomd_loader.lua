--[[
  LinoriaCustomD loader — custom Linoria fork (mobile sizing, optional custom font).
  Menu toggle: RightControl / RightShift
]]

print("[LinoriaCustomD] loader start")
repeat task.wait() until game:IsLoaded()

local GH = "https://raw.githubusercontent.com/alphamego/roblox-loaders/main/linoriacustomd"
local BASE = getgenv().LINORIACUSTOMD_URL or GH

local loadstring = loadstring or load
if not loadstring then
	error("[LinoriaCustomD] loadstring missing")
end
getgenv().loadstring = loadstring

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
	error("[LinoriaCustomD] no HttpGet/request")
end

local function loadFromSource(label, src)
	if not src or #src < 500 then
		error(label .. " empty")
	end
	local head = src:sub(1, 20):lower()
	if head:find("<!doctype") or head:find("<html") then
		error(label .. " returned HTML")
	end
	local fn, err = loadstring(src)
	if not fn then
		error(label .. " compile: " .. tostring(err))
	end
	local ok, result = pcall(fn)
	if not ok then
		error(label .. " runtime: " .. tostring(result))
	end
	return result
end

local function tryLocal(path)
	if not (readfile and isfile and isfile(path)) then
		return nil
	end
	return loadFromSource(path, readfile(path))
end

local function fetch(path)
	return loadFromSource(path, httpGet(BASE .. "/" .. path))
end

local Library = tryLocal("linoriacustomd/Library.lua")
	or tryLocal("Library.lua")
if not Library then
	Library = fetch("Library.lua")
end

if not Library or not Library.CreateWindow then
	error("[LinoriaCustomD] Library invalid")
end

local ThemeManager = tryLocal("linoriacustomd/addons/ThemeManager.lua")
	or fetch("addons/ThemeManager.lua")
local SaveManager = tryLocal("linoriacustomd/addons/SaveManager.lua")
	or fetch("addons/SaveManager.lua")

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:SetFolder("LinoriaCustomD/Themes")
SaveManager:SetFolder("LinoriaCustomD/Configs")
SaveManager:BuildFolderTree()
ThemeManager:BuildFolderTree()

getgenv().Library = Library
getgenv().ThemeManager = ThemeManager
getgenv().SaveManager = SaveManager

local Window = Library:CreateWindow({
	Title = "LinoriaCustomD",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

local Tabs = {
	Main = Window:AddTab("Main"),
	Settings = Window:AddTab("Settings"),
}

Tabs.Main:AddLeftGroupbox("Demo"):AddLabel("LinoriaCustomD loaded (blue theme, mobile-friendly)")
Tabs.Main:AddRightGroupbox("Test"):AddToggle("ExampleToggle", {
	Text = "Example toggle",
	Default = false,
})

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

Library:Notify("LinoriaCustomD loaded", 3)
print("[LinoriaCustomD] ok — toggle: RightControl / RightShift")
