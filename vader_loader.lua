--[[
  Vader UI loader (fixed demo)
  - Opens first tab so content is visible
  - Hides watermark / playerlist / keybind sidebar clutter
  - Paste vader_execute.lua in executor for one-liner load
]]

print("[Vader] loader start")
repeat task.wait() until game:IsLoaded()

-- Set this after uploading to YOUR GitHub (raw URL to this file or vader.lua)
local GH = "https://raw.githubusercontent.com/alphamego/roblox-loaders/main"
local LOADER_RAW = getgenv().VADER_LOADER_URL
local LIB_RAW = getgenv().VADER_LIB_URL or (GH .. "/vader.lua")

local loadstring = loadstring or load
if not loadstring then
	error("[Vader] loadstring missing")
end

local required = { "makefolder", "writefile", "readfile", "isfile", "listfiles", "getcustomasset" }
for _, name in ipairs(required) do
	if not getgenv()[name] and not _G[name] then
		error("[Vader] missing executor API: " .. name)
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
	error("[Vader] no HttpGet/request")
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

local function tryLocal()
	if not isfile then
		return nil
	end
	for _, path in ipairs({ "vader.lua", "vader_remake/src.lua", "src.lua" }) do
		if isfile(path) then
			print("[Vader] local:", path)
			return loadFromSource(path, readfile(path))
		end
	end
	return nil
end

local library = tryLocal()
if not library then
	print("[Vader] fetching library")
	library = loadFromSource("vader", httpGet(LIB_RAW))
end

if type(library) ~= "table" or type(library.window) ~= "function" then
	error("[Vader] invalid library")
end

getgenv().Vader = library
getgenv().library = library

local menuOpen = true
local window = library:window({
	name = "Vader",
	title = "Vader",
	size = UDim2.fromOffset(520, 580),
})

-- Less clutter — notification stays (you liked that)
pcall(function()
	window:toggle_watermark(false)
	window:toggle_list(false)
	window:toggle_playerlist(false)
end)

local mainTab = window:tab({ name = "Main" })
local mainSection = mainTab:section({ name = "General", side = "left" })

mainSection:toggle({
	name = "Example toggle",
	flag = "vader_demo_toggle",
	default = false,
	callback = function(v)
		print("[Vader] toggle:", v)
	end,
})

mainSection:slider({
	name = "Example slider",
	flag = "vader_demo_slider",
	min = 0,
	max = 100,
	default = 50,
	callback = function(v)
		print("[Vader] slider:", v)
	end,
})

mainSection:button({
	name = "Notify test",
	callback = function()
		library:notification({ text = "Vader notification", time = 3 })
	end,
})

local extraSection = mainTab:section({ name = "Extra", side = "right" })
extraSection:dropdown({
	name = "Pick one",
	flag = "vader_demo_dropdown",
	items = { "Alpha", "Beta", "Gamma" },
	default = "Alpha",
	callback = function(v)
		print("[Vader] dropdown:", v)
	end,
})

local settingsTab = window:tab({ name = "Settings" })
settingsTab:section({ name = "Menu", side = "left" }):toggle({
	name = "Show keybind list",
	flag = "vader_show_kblist",
	default = false,
	callback = function(v)
		window:toggle_list(v)
	end,
})

-- CRITICAL: first tab content is Visible=false until open_tab runs
mainTab.open_tab()

window:set_menu_visibility(true, false)

local uis = game:GetService("UserInputService")
library:connection(uis.InputBegan, function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
		menuOpen = not menuOpen
		window:set_menu_visibility(menuOpen, false)
	end
end)

library:notification({ text = "Vader loaded", time = 4 })
print("[Vader] ok — toggle menu: Insert / RightShift")
if LOADER_RAW then
	print("[Vader] loaded from:", LOADER_RAW)
end
