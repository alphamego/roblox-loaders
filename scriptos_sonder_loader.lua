--[[
  Scriptos — Sonder / Scoot UI loader (by samet)
  Mint-accent modern UI with search, resize, built-in settings page.
  Menu toggle: RightControl
]]

print("[Sonder] loader start")
repeat task.wait() until game:IsLoaded()

local GH = "https://raw.githubusercontent.com/alphamego/roblox-loaders/main/scriptos/sonder"
getgenv().SCRIPTOS_SONDER_BASE = getgenv().SCRIPTOS_SONDER_BASE or GH
local BASE = getgenv().SCRIPTOS_SONDER_URL or GH

getgenv().gethui = getgenv().gethui or function()
	return game:GetService("CoreGui")
end

local loadstring = loadstring or load
if not loadstring then
	error("[Sonder] loadstring missing")
end

local required = { "makefolder", "writefile", "readfile", "isfile", "getcustomasset", "delfile", "listfiles" }
for _, name in ipairs(required) do
	if not getgenv()[name] and not _G[name] then
		error("[Sonder] missing executor API: " .. name)
	end
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
	error("[Sonder] no HttpGet/request")
end

local function loadFromSource(label, src)
	if not src or #src < 1000 then
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

local function tryLocal()
	if not isfile then
		return nil
	end
	for _, path in ipairs({ "scriptos/sonder/Library.lua", "Sonder/Library.lua" }) do
		if isfile(path) then
			print("[Sonder] local:", path)
			return loadFromSource(path, readfile(path))
		end
	end
	return nil
end

local Library = tryLocal()
if not Library then
	print("[Sonder] fetching:", BASE .. "/Library.lua")
	Library = loadFromSource("Sonder", httpGet(BASE .. "/Library.lua"))
end

if not Library or not Library.Window then
	error("[Sonder] Library invalid")
end

getgenv().Library = Library
getgenv().Sonder = Library

local Window = Library:Window({})
local Page = Window:Page({ Name = "Main" })
local Section = Page:Section({ Name = "Demo", Side = 1 })
Section:Label({ Name = "Sonder loaded (Scriptos)" })
Section:Toggle({ Name = "Example toggle", Flag = "sonder_example", Default = false })

local Watermark = Library:Watermark("Sonder")
local KeybindList = Library:KeybindList()
Library:CreateSettingsPage(Window, Watermark, KeybindList)

Window:SetOpen(true)
Library:Notification("Success", "Sonder loaded", 3)
print("[Sonder] ok — toggle menu: RightControl")
