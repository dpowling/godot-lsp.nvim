# godot-lsp.nvim

A simple Neovim plugin for connecting to Godot's built-in Language Server Protocol (LSP) server.

## ✨ Features

- 🚀 **Automatic LSP connection** when opening GDScript files
- 🎯 **Project detection** via `project.godot` files
- 🔄 **Port fallback** (tries 6005, then 6006)
- 🐛 **Debug mode** for troubleshooting
- ⚙️ **Configurable** with sensible defaults

## 📋 Requirements

- Neovim 0.8+ (for `vim.lsp.rpc.connect`)
- Godot 4.x

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "dpowling/godot-lsp.nvim",
  ft = "gdscript",
  opts = {
    -- your configuration here (optional)
  }
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "dpowling/godot-lsp.nvim",
  ft = "gdscript",
  config = function()
    require("godot-lsp").setup()
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'dpowling/godot-lsp.nvim'
```

Then in your `init.lua`:

```lua
require("godot-lsp").setup()
```

## ⚙️ Configuration

```lua
require("godot-lsp").setup({
  port = 6005,              -- Primary port to connect to
  fallback_port = 6006,     -- Fallback port if primary fails
  auto_start = true,        -- Automatically start LSP when opening GDScript files
  debug = false,            -- Enable debug output
  silent = true,            -- Only show error messages (set to false for startup info)
})
```

### Default Configuration

The plugin works out of the box with these defaults:

- **Port**: 6005 (Godot's default LSP port)
- **Fallback port**: 6006
- **Auto-start**: Enabled
- **Debug**: Disabled
- **Silent**: Enabled (only shows errors)

## 🎮 Godot Setup

1. **Start your Godot project**:
   - Open your project in Godot
   - The LSP server will automatically start

2. **Open GDScript files in Neovim**:
   - The plugin will automatically detect your project and connect to the LSP

## 🔧 Commands

The plugin provides a few helpful commands:

```lua
-- Manually start the LSP (if auto_start is disabled)
require("godot-lsp").start()

-- Check LSP status
require("godot-lsp").status()
```

## 🐛 Troubleshooting

### LSP not connecting?

1. **Enable debug mode**:

   ```lua
   require("godot-lsp").setup({
     debug = true
   })
   ```

2. **Check Godot LSP is running**:

   ```bash
   ss -tlnp | grep :6005
   ```

3. **Verify project structure**:
   - Make sure you have a `project.godot` file in your project root
   - Open Neovim from within the Godot project directory

4. **Check Neovim version**:

   ```vim
   :version
   ```

   (Requires Neovim 0.8+)

### Common Issues

- **"No project.godot found"**: Make sure you're opening files within a Godot project
- **"Failed to connect"**: Ensure Godot is running with LSP enabled
- **Multiple LSP instances**: The plugin prevents this automatically

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

- Thanks to the Godot team for providing an excellent built-in LSP server
- Inspired by the Neovim LSP ecosystem and the need for a simple Godot LSP solution
