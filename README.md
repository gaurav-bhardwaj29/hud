# OverlayHUD.spoon

Simple transparent HUD showing CPU%, swap used and idle time.

## Installation

1. Download the latest release from the [Releases page](https://github.com/gaurav-bhardwaj29/hud.spoon/releases)
2. Double-click the downloaded `.spoon` file to install it in your Hammerspoon directory
3. Add the following to your `~/.hammerspoon/init.lua`:

```lua
-- Load the spoon
hs.loadSpoon("OverlayHUD")
-- Start the HUD
spoon.OverlayHUD:start()
```

## Usage
- Toggle the HUD: ⌘⌥S (Command + Option + S)
- The HUD shows:
  - CPU usage percentage
  - Swap memory used
  - System idle time

## Configuration
You can customize the appearance and behavior by setting these options before calling `start()`:

```lua
spoon.OverlayHUD.fontSize = 14
spoon.OverlayHUD.position = { x = 20, y = 40 }  -- Top-left position
spoon.OverlayHUD.backgroundColor = { white = 0, alpha = 0.7 }  -- Semi-transparent black
spoon.OverlayHUD.textColor = { white = 1, alpha = 1 }  -- White text
```

## License
MIT License - See the [LICENSE](LICENSE) file for details.
