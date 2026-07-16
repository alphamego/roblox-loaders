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

## Scriptos (3 libraries)

From [fullysore/Scriptos](https://github.com/fullysore/Scriptos) — three separate UI libs:

**Atlanta** — purple dock UI, blur, configs, Drawing + file APIs. Toggle: **Insert**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/scriptos_atlanta_loader.lua"))()
```

**Sonder** (Scoot UI by samet) — mint theme, search, resize. Toggle: **RightControl**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/scriptos_sonder_loader.lua"))()
```

**Linoria Rewrite** — purple Linoria fork with rainbow. Toggle: **RightControl** / **RightShift**

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/alphamego/roblox-loaders/main/scriptos_linoria_rewrite_loader.lua"))()
```

## Local

```lua
loadstring(readfile("vader_loader.lua"))()
```

Menu toggle: **Insert** / **RightShift**
