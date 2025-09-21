local M = {}

local default_config = {
	port = 6005,
	fallback_port = 6006,
	auto_start = true,
	debug = false,
	silent = true, -- Only show messages on errors/important events
}

local config = default_config

local function debug_print(...)
	if config.debug then
		print("godot-lsp:", ...)
	end
end

local function info_print(...)
	if not config.silent then
		print("godot-lsp:", ...)
	end
end

local function error_print(...)
	print("godot-lsp ERROR:", ...)
end

local started_projects = {}

local function start_godot_lsp()
	local root = vim.fs.root(0, { "project.godot" })
	if not root then
		debug_print("No project.godot found")
		return
	end

	if started_projects[root] then
		debug_print("LSP already started for this project")
		return
	end

	-- Check if gdscript LSP is already running for this buffer
	local clients = vim.lsp.get_clients({ name = "gdscript" })
	for _, client in ipairs(clients) do
		if client.root_dir == root then
			debug_print("LSP already running for this project")
			started_projects[root] = true
			return -- Already running
		end
	end

	debug_print("Starting Godot LSP for project:", root)
	started_projects[root] = true

	-- Try primary port first, then fallback
	local function try_connect(port)
		local success, cmd = pcall(vim.lsp.rpc.connect, "127.0.0.1", port)
		if success and cmd then
			debug_print("Connected via RPC on port", port)
			return cmd
		end
		return nil
	end

	local cmd = try_connect(config.port)
	if not cmd and config.fallback_port then
		debug_print("Primary port failed, trying fallback port", config.fallback_port)
		cmd = try_connect(config.fallback_port)
	end

	if not cmd then
		error_print("Failed to connect to Godot LSP server on ports", config.port, "and", config.fallback_port)
		return
	end

	vim.lsp.start({
		name = "gdscript",
		cmd = cmd,
		root_dir = root,
		filetypes = { "gdscript" },
	})

	info_print("LSP started for project:", vim.fn.fnamemodify(root, ":t"))
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", default_config, opts or {})

	if not config.auto_start then
		debug_print("Auto-start disabled")
		return
	end

	debug_print("Setting up Godot LSP autocommands")

	-- Create autocommands to start LSP when opening GDScript files
	local augroup = vim.api.nvim_create_augroup("GodotLSP", { clear = true })

	-- Primary trigger: when filetype is set to gdscript
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "gdscript",
		callback = function()
			debug_print("FileType gdscript detected")
			start_godot_lsp()
		end,
		group = augroup,
	})

	-- Backup trigger: when entering a .gd file that might not have filetype set yet
	vim.api.nvim_create_autocmd("BufWinEnter", {
		pattern = "*.gd",
		callback = function()
			if vim.bo.filetype == "gdscript" or vim.fn.expand("%:e") == "gd" then
				debug_print("BufWinEnter .gd file detected")
				-- Small delay to ensure filetype is set
				vim.defer_fn(start_godot_lsp, 50)
			end
		end,
		group = augroup,
	})
end

function M.start()
	start_godot_lsp()
end

function M.status()
	local clients = vim.lsp.get_clients({ name = "gdscript" })
	if #clients > 0 then
		for _, client in ipairs(clients) do
			print("Godot LSP running for project:", vim.fn.fnamemodify(client.root_dir, ":t"))
		end
	else
		print("Godot LSP not running")
		started_projects = {}
	end
end

function M.reset()
	started_projects = {}
	print("Godot LSP tracking reset")
end

return M

