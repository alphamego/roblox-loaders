--[[
  ONE-LINER — paste this entire file into your executor and run.

  Option A — files in executor workspace (fastest, no GitHub):
    Put vader.lua + vader_loader.lua in your executor folder, then:
]]
loadstring(readfile("vader_loader.lua"))()

--[[
  Option B — your GitHub raw URL (after upload):
    1. Create a repo on GitHub (public)
    2. Upload vader_loader.lua (and optionally vader.lua)
    3. Replace USER and REPO below, then uncomment Option B and comment Option A

  getgenv().VADER_LOADER_URL = "https://raw.githubusercontent.com/USER/REPO/main/vader_loader.lua"
  getgenv().VADER_LIB_URL = "https://raw.githubusercontent.com/USER/REPO/main/vader.lua"
  loadstring(game:HttpGet(getgenv().VADER_LOADER_URL))()

  Option C — dementiaenjoyer upstream library only (loader still local):
  loadstring(readfile("vader_loader.lua"))()
]]
