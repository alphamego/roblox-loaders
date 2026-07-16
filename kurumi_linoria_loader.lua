--[[
  Kurumi Linoria loader — Secret4869 themed fork (library-only file).
  URL pinned to commit 4d733b4 for stability.
]]

print("[Kurumi Linoria] loader start")
repeat task.wait() until game:IsLoaded()

local KURUMI_URL =
	"https://raw.githubusercontent.com/Secret4869/Secret/4d733b4acf91ee86472a7cd2ae5a06bebfdb2eb2/Linoria/Kurumi_Linoria.lua"
local MS_REPO = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"

local loadstring = loadstring or load
if not loadstring then
	error("[Kurumi Linoria] loadstring missing")
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
	error("[Kurumi Linoria] no HttpGet/request")
end

local function loadFromSource(label, src)
	if not src or #src < 100 then
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

local function tryLocal()
	if not (readfile and isfile) then
		return nil
	end
	for _, path in ipairs({ "Kurumi_Linoria.lua", "kurumi_linoria.lua", "Linoria/Kurumi_Linoria.lua" }) do
		if isfile(path) then
			print("[Kurumi Linoria] local:", path)
			return loadFromSource(path, readfile(path))
		end
	end
	return nil
end

local Library = tryLocal()
if not Library then
	print("[Kurumi Linoria] fetching GitHub")
	Library = loadFromSource("Kurumi_Linoria.lua", httpGet(KURUMI_URL))
end

Library = Library or getgenv().Library
if not Library or not Library.CreateWindow then
	error("[Kurumi Linoria] Library invalid")
end

-- Optional: mstudio45 addons (same Linoria API; may not match every Kurumi tweak)
pcall(function()
	local ThemeManager = loadFromSource("ThemeManager", httpGet(MS_REPO .. "addons/ThemeManager.lua"))
	local SaveManager = loadFromSource("SaveManager", httpGet(MS_REPO .. "addons/SaveManager.lua"))
	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	ThemeManager:SetFolder("Kurumi/Themes")
	SaveManager:SetFolder("Kurumi/Configs")
	SaveManager:BuildFolderTree()
	ThemeManager:BuildFolderTree()
	getgenv().ThemeManager = ThemeManager
	getgenv().SaveManager = SaveManager
end)

local Window = Library:CreateWindow({
	Title = "Kurumi Linoria",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
})

local Tabs = {
	Main = Window:AddTab("Main"),
	Settings = Window:AddTab("Settings"),
}

Tabs.Main:AddLeftGroupbox("Demo"):AddLabel("Kurumi Linoria loaded (FredokaOne / purple theme)")

if getgenv().SaveManager and getgenv().ThemeManager then
	pcall(function()
		getgenv().SaveManager:BuildConfigSection(Tabs.Settings)
		getgenv().ThemeManager:ApplyToTab(Tabs.Settings)
		getgenv().SaveManager:LoadAutoloadConfig()
	end)
end

Library:Notify("Kurumi Linoria loaded", 4)
print("[Kurumi Linoria] ok — toggle: RightControl / RightShift")
print("[Kurumi Linoria] getgenv().Library / Options / Toggles ready")
