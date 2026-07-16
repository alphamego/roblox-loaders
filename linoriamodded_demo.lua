--[[
  LinoriaModded — component showcase (black / purple)
  Menu toggle: RightControl / RightShift
]]

print("[LinoriaModded] demo start")
repeat task.wait() until game:IsLoaded()

local GH = "https://raw.githubusercontent.com/alphamego/roblox-loaders/main/linoriamodded"
local BASE = (typeof(getgenv) == "function" and getgenv().LINORIAMODDED_URL) or GH

local loadstring = loadstring or load
assert(loadstring, "[LinoriaModded] loadstring missing")

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
	error("[LinoriaModded] no HttpGet/request")
end

local function loadFromSource(label, src)
	assert(src and #src > 200, label .. " empty")
	local fn, err = loadstring(src)
	assert(fn, label .. " compile: " .. tostring(err))
	local ok, result = pcall(fn)
	assert(ok, label .. " runtime: " .. tostring(result))
	return result
end

local function tryLocal(path)
	if readfile and isfile and isfile(path) then
		return loadFromSource(path, readfile(path))
	end
	return nil
end

local function fetch(path)
	return loadFromSource(path, httpGet(BASE .. "/" .. path))
end

local Library = tryLocal("linoriamodded/Library.lua") or fetch("Library.lua")
assert(Library and Library.CreateWindow, "[LinoriaModded] Library invalid")

local ThemeManager = tryLocal("linoriamodded/addons/ThemeManager.lua") or fetch("addons/ThemeManager.lua")
local SaveManager = tryLocal("linoriamodded/addons/SaveManager.lua") or fetch("addons/SaveManager.lua")

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager.DefaultTheme = "BlackPurple"
ThemeManager:SetFolder("LinoriaModded/Themes")
SaveManager:SetFolder("LinoriaModded/Configs")
pcall(function()
	SaveManager:BuildFolderTree()
	ThemeManager:BuildFolderTree()
end)

getgenv().Library = Library
getgenv().Linoria = Library
getgenv().Toggles = Library.Toggles
getgenv().Options = Library.Options
getgenv().ThemeManager = ThemeManager
getgenv().SaveManager = SaveManager

local Toggles = Library.Toggles
local Options = Library.Options

local Window = Library:CreateWindow({
	Title = "LinoriaModded - Component Showcase",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2,
	-- Wider so most tabs fit; leftover tabs scroll horizontally (mouse wheel / touch swipe)
	Size = UDim2.fromOffset(720, 560),
})

local Tabs = {
	Controls = Window:AddTab("Controls"),
	Dropdowns = Window:AddTab("Dropdowns"),
	Keybinds = Window:AddTab("Keybinds"),
	Labels = Window:AddTab("Labels"),
	UISettings = Window:AddTab("UI Settings"),
}

-- Controls
do
	local Left = Tabs.Controls:AddLeftGroupbox("Toggles & Sliders")
	local Right = Tabs.Controls:AddRightGroupbox("Buttons & Inputs")

	Left:AddToggle("EnableFeature", {
		Text = "Enable Feature",
		Default = false,
	})

	Left:AddToggle("RiskyOption", {
		Text = "Risky Option",
		Default = false,
		Risky = true,
	})

	Left:AddSlider("WalkSpeed", {
		Text = "Walk Speed",
		Default = 16,
		Min = 0,
		Max = 200,
		Rounding = 0,
		Suffix = " stud/s",
	})

	Left:AddSlider("FieldOfView", {
		Text = "Field of View",
		Default = 70,
		Min = 50,
		Max = 120,
		Rounding = 0,
		Suffix = "°",
	})

	Left:AddSlider("Transparency", {
		Text = "Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
	})

	Right:AddButton("Click Me!", function()
		Library:Notify("Button clicked!", 2)
	end)

	Right:AddButton("Notify Test", function()
		Library:Notify({
			Title = "LinoriaModded",
			Description = "Black / purple theme active",
			Time = 3,
		})
	end)

	Right:AddInput("TargetPlayer", {
		Text = "Target Player",
		Default = "",
		Placeholder = "Enter a name...",
	})

	Right:AddInput("DamageValue", {
		Text = "Damage Value",
		Default = "100",
		Numeric = true,
	})
end

-- Dropdowns & Colors
do
	local Left = Tabs.Dropdowns:AddLeftGroupbox("Dropdowns")
	local Right = Tabs.Dropdowns:AddRightGroupbox("Colors")

	Left:AddDropdown("PickOne", {
		Text = "Pick one",
		Values = { "Alpha", "Beta", "Gamma", "Delta" },
		Default = 1,
	})

	Left:AddDropdown("MultiPick", {
		Text = "Multi select",
		Values = { "ESP", "Aimbot", "Fly", "Noclip" },
		Multi = true,
		Default = {},
	})

	Right:AddLabel("Accent preview"):AddColorPicker("AccentPreview", {
		Default = Library.AccentColor,
	})

	Right:AddLabel("Outline preview"):AddColorPicker("OutlinePreview", {
		Default = Library.OutlineColor,
	})
end

-- Keybinds & Deps
do
	local Left = Tabs.Keybinds:AddLeftGroupbox("Keybinds")
	local Right = Tabs.Keybinds:AddRightGroupbox("Dependencies")

	Left:AddToggle("FeatureWithKey", {
		Text = "Feature with key",
		Default = false,
	}):AddKeyPicker("FeatureKey", {
		Default = "F",
		Mode = "Toggle",
		Text = "Feature",
		SyncToggleState = true,
	})

	Right:AddToggle("ParentToggle", {
		Text = "Parent toggle",
		Default = false,
	})

	Right:AddSlider("ChildSlider", {
		Text = "Child slider",
		Default = 50,
		Min = 0,
		Max = 100,
		Rounding = 0,
	})

	-- Use Library.Toggles / Options (not bare globals)
	if Toggles.ParentToggle and Options.ChildSlider then
		Options.ChildSlider:SetVisible(false)
		Toggles.ParentToggle:OnChanged(function()
			Options.ChildSlider:SetVisible(Toggles.ParentToggle.Value)
		end)
	end
end

-- Labels & Misc
do
	local Left = Tabs.Labels:AddLeftGroupbox("Info")
	Left:AddLabel("LinoriaModded showcase")
	Left:AddLabel("Scroll the tab bar (wheel / swipe) if tabs overflow")
	Left:AddLabel("Mobile: swipe the tab row horizontally")
	Left:AddDivider()
	Left:AddLabel("Toggle menu: RightControl / RightShift")
end

-- UI Settings
do
	local Left = Tabs.UISettings:AddLeftGroupbox("Window")
	local Right = Tabs.UISettings:AddRightGroupbox("Theme & Config")

	Left:AddToggle("GhostDragToggle", {
		Text = "Ghost drag outline",
		Default = Library.GhostDrag == true,
		Tooltip = "White outline moves while dragging; window snaps on release",
		Callback = function(v)
			Library.GhostDrag = v
		end,
	})

	Left:AddToggle("CustomCursorToggle", {
		Text = "Show custom cursor",
		Default = Library.ShowCustomCursor ~= false,
		Callback = function(v)
			Library.ShowCustomCursor = v
		end,
	})

	Left:AddDropdown("UIFontPicker", {
		Text = "UI Font",
		Values = Library.AvailableFonts or { "Plex", "Code", "Ubuntu", "SourceSans", "Gotham", "Arcade" },
		Default = Library.CurrentFontName or "Plex",
		Callback = function(v)
			Library:SetUIFont(v)
		end,
	})

	Left:AddToggle("WatermarkToggle", {
		Text = "Show watermark",
		Default = true,
		Callback = function(v)
			if v then
				Library:StartWatermark()
			else
				Library:StopWatermark()
			end
		end,
	})

	Left:AddInput("WatermarkFormat", {
		Text = "Watermark text",
		Default = Library.WatermarkFormat or "LinoriaModded | {fps} FPS",
		Placeholder = "Use {fps} for FPS",
		Finished = true,
		Callback = function(v)
			if type(v) == "string" and #v > 0 then
				Library:SetWatermarkFormat(v)
				if Library.WatermarkEnabled then
					Library:StartWatermark()
				end
			end
		end,
	})

	Left:AddDropdown("NotifySide", {
		Text = "Notify side",
		Values = { "Left", "Right" },
		Default = 1,
		Callback = function(v)
			if Library.SetNotifySide then
				Library:SetNotifySide(v)
			else
				Library.NotifySide = v
			end
		end,
	})

	Left:AddButton("Unload UI", function()
		Library:StopWatermark()
		Library:Unload()
	end)

	ThemeManager:ApplyToGroupbox(Right)
	SaveManager:BuildConfigSection(Tabs.UISettings)
end

pcall(function()
	ThemeManager:ApplyTheme("BlackPurple")
end)

-- Default watermark with FPS
Library:StartWatermark("LinoriaModded | {fps} FPS")

Library:Notify({
	Title = "LinoriaModded",
	Description = "Loaded — check UI Settings for fonts / watermark",
	Time = 3,
})
print("[LinoriaModded] ok — font picker + watermark in UI Settings; swipe/scroll tab bar for more tabs")
