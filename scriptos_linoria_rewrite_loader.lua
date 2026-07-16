--[[
  Scriptos — Linoria Rewrite loader
  Purple/dark Linoria fork with rainbow support.
  Menu toggle: RightControl / RightShift
]]

print("[Linoria Rewrite] loader start")
repeat task.wait() until game:IsLoaded()

local GH = "https://raw.githubusercontent.com/alphamego/roblox-loaders/main/scriptos/linoria-rewrite"
local BASE = getgenv().SCRIPTOS_LINORIA_URL or GH

local loadstring = loadstring or load
if not loadstring then
	error("[Linoria Rewrite] loadstring missing")
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
	error("[Linoria Rewrite] no HttpGet/request")
end

local function loadFromSource(label, src)
	if not src or #src < 500 then
		error(label .. " empty")
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

local Library = tryLocal("scriptos/linoria-rewrite/Library.lua")
	or tryLocal("Linoria Rewrite.lua")
if not Library then
	Library = fetch("Library.lua")
end

if not Library or not Library.CreateWindow then
	error("[Linoria Rewrite] Library invalid")
end

local ThemeManager = tryLocal("scriptos/linoria-rewrite/addons/ThemeManager.lua")
	or fetch("addons/ThemeManager.lua")
local SaveManager = tryLocal("scriptos/linoria-rewrite/addons/SaveManager.lua")
	or fetch("addons/SaveManager.lua")

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:SetFolder("LinoriaRewrite/Themes")
SaveManager:SetFolder("LinoriaRewrite/Configs")
SaveManager:BuildFolderTree()
ThemeManager:BuildFolderTree()

getgenv().Library = Library
getgenv().ThemeManager = ThemeManager
getgenv().SaveManager = SaveManager

local Window = Library:CreateWindow({
	Title = "Linoria Rewrite",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
})

local Tabs = {
	Main = Window:AddTab("Main"),
	Settings = Window:AddTab("Settings"),
}

Tabs.Main:AddLeftGroupbox("Demo"):AddLabel("Linoria Rewrite loaded (purple theme)")
Tabs.Main:AddRightGroupbox("Test"):AddToggle("ExampleToggle", {
	Text = "Example toggle",
	Default = false,
})

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

Library:Notify("Linoria Rewrite loaded", 3)
print("[Linoria Rewrite] ok — toggle: RightControl / RightShift")
