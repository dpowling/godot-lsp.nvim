-- Example lazy.nvim plugin specification
-- Add this to your lazy.nvim plugin configuration

return {
  "your-username/godot-lsp.nvim",
  ft = "gdscript", -- Only load when opening GDScript files
  opts = {
    -- Configuration options (all optional)
    port = 6005,              -- Primary port to connect to
    fallback_port = 6006,     -- Fallback port if primary fails
    auto_start = true,        -- Automatically start LSP when opening GDScript files
    debug = false,            -- Enable debug output
  },
  -- Alternative configuration method:
  -- config = function()
  --   require("godot-lsp").setup({
  --     debug = true, -- Enable for troubleshooting
  --   })
  -- end,
}