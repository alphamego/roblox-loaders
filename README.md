# Roblox UI loaders

Executor loaders for Vader, Velocity, Kurumi Linoria.

## Vader (one-liner)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/vader_loader.lua"))()
```

With hosted library:

```lua
getgenv().VADER_LIB_URL = "https://raw.githubusercontent.com/USER/REPO/main/vader.lua"
loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/vader_loader.lua"))()
```

## Local

```lua
loadstring(readfile("vader_loader.lua"))()
```

Menu toggle: **Insert** / **RightShift**
