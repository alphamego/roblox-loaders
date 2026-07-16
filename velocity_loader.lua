--[[
  Velocity UI loader — dementiaenjoyer velocity (source + example combined).
  Pinned commit: 2c77447
  Uses patched local velocity.lua (fixes menu flash/disappear race).
]]

print("[Velocity] loader start")
repeat task.wait() until game:IsLoaded()

local VELOCITY_URL =
	"https://raw.githubusercontent.com/dementiaenjoyer/UI-LIBRARIES/2c77447bf98d60361b47b9ffb3159d018a4e387b/velocity/source%20and%20example.lua"

local PATCH_OPEN_RACE = [[
        self._openToken = (self._openToken or 0) + 1
        local token = self._openToken
]]

local loadstring = loadstring or load
if not loadstring then
	error("[Velocity] loadstring missing")
end

local required = { "makefolder", "isfolder", "writefile", "readfile", "isfile", "listfiles", "delfile" }
for _, name in ipairs(required) do
	if not getgenv()[name] and not _G[name] then
		error("[Velocity] missing executor API: " .. name)
	end
end

if not (Drawing and Drawing.new) then
	error("[Velocity] Drawing API missing — Velocity uses custom Drawing UI")
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
	error("[Velocity] no HttpGet/request")
end

local function patchSource(src)
	if not src:find("_openToken", 1, true) then
		src = src:gsub(
			"(function library:SetOpen%(bool%)[\s\S]-self%.open = bool;)",
			"%1\n" .. PATCH_OPEN_RACE
		)
		src = src:gsub(
			"(if not bool then%s+task%.wait%(.1%);%s+end%s+)self%.holder%.Visible = bool;",
			"%1if token ~= self._openToken then return end\n            self.holder.Visible = bool;"
		)
	end
	return src
end

local function loadFromSource(label, src)
	src = patchSource(src)
	if not src or #src < 1000 then
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
	local ok, lib, cfg = pcall(fn)
	if not ok then
		error(label .. " runtime: " .. tostring(lib))
	end
	return lib, cfg
end

local function tryLocal()
	if not isfile then
		return nil
	end
	for _, path in ipairs({ "velocity.lua", "velocity/source and example.lua" }) do
		if isfile(path) then
			print("[Velocity] local:", path)
			return loadFromSource(path, readfile(path))
		end
	end
	return nil
end

local library, settings = tryLocal()
if not library then
	print("[Velocity] fetching GitHub (large file, may take a few seconds)")
	library, settings = loadFromSource("velocity", httpGet(VELOCITY_URL))
end

getgenv().Velocity = library
getgenv().velocity = library
getgenv().velocity_settings = settings

print("[Velocity] loaded — toggle menu with End")
