--[[
  ZeroLinoria loader — red/rainbow themed Linoria fork with rounded UI.
  Optional Solance subscription label (localhost:9999/auth).
  Menu toggle: RightControl / RightShift
]]

print("[ZeroLinoria] loader start")
repeat task.wait() until game:IsLoaded()

local GH = "https://raw.githubusercontent.com/alphamego/roblox-loaders/main/zerolinoria"
local BASE = getgenv().ZEROLINORIA_URL or GH

local loadstring = loadstring or load
if not loadstring then
	error("[ZeroLinoria] loadstring missing")
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
	error("[ZeroLinoria] no HttpGet/request")
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

local Library = tryLocal("zerolinoria/Library.lua")
	or tryLocal("Library.lua")
if not Library then
	Library = fetch("Library.lua")
end

if not Library or not Library.CreateWindow then
	error("[ZeroLinoria] Library invalid")
end

local ThemeManager = tryLocal("zerolinoria/addons/ThemeManager.lua")
	or fetch("addons/ThemeManager.lua")
local SaveManager = tryLocal("zerolinoria/addons/Savemanager.lua")
	or tryLocal("zerolinoria/addons/SaveManager.lua")
	or fetch("addons/Savemanager.lua")

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:SetFolder("ZeroLinoria/Themes")
SaveManager:SetFolder("ZeroLinoria/Configs")
SaveManager:BuildFolderTree()
ThemeManager:BuildFolderTree()

getgenv().Library = Library
getgenv().ThemeManager = ThemeManager
getgenv().SaveManager = SaveManager

local Window = Library:CreateWindow({
	Title = "ZeroLinoria",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

local Tabs = {
	Main = Window:AddTab("Main"),
	Settings = Window:AddTab("Settings"),
}

Tabs.Main:AddLeftGroupbox("Demo"):AddLabel("ZeroLinoria loaded (red accent, rounded UI)")
Tabs.Main:AddRightGroupbox("Test"):AddToggle("ExampleToggle", {
	Text = "Example toggle",
	Default = false,
})

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

Library:Notify("ZeroLinoria loaded", 3)
print("[ZeroLinoria] ok — toggle: RightControl / RightShift")
print("[ZeroLinoria] subscription label needs Solance auth on localhost:9999 (optional)")
