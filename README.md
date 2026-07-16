# Roblox UI loaders

Executor loaders for Vader, Velocity, Kurumi Linoria.

## Vader (one-liner)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/vader_loader.lua"))()
```

With hosted library:

```lua
getgenv().VADER_LIB_URL = "https://raw.githubusercontent.com/alphamego/roblox-loaders/main/vader.lua"
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/vader_loader.lua"))()
```

Menu toggle: **Insert** / **RightShift**

## Velocity (one-liner)

Requires **Drawing API** and executor file APIs (`makefolder`, `writefile`, etc.).

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/velocity_loader.lua"))()
```

Or load the full script directly:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/velocity.lua"))()
```

Menu toggle: **End**

## LinoriaCustomD

Blue-accent Linoria fork with mobile-friendly window sizing and optional custom font (`getcustomasset`).

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/linoriacustomd_loader.lua"))()
```

Menu toggle: **RightControl** / **RightShift**

## ZeroLinoria

Red/rainbow themed Linoria with rounded UI (`ApplyDesign`). Shows Solance subscription days if auth is on `localhost:9999` (optional, does not block the menu).

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/zerolinoria_loader.lua"))()
```

Menu toggle: **RightControl** / **RightShift**

## Local

```lua
loadstring(readfile("vader_loader.lua"))()
```

Menu toggle: **Insert** / **RightShift**
