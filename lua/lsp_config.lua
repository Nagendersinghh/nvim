local nvim_lsp = require('lspconfig')
local api, util = vim.api, vim.lsp.util

local npcall = vim.F.npcall

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) api.nvim_buf_set_keymap(bufnr, ...) end

	-- Mappings.
	local opts = { noremap = true, silent = true }

	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	-- TODO: Think of something else. <C-k> is used for navigating splits
	-- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	-- TODO: <leader>wa is used for save all
	-- buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	-- TODO: <leader>r is used for grep across project.
	-- buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '<leader>p', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', '<leader>n', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	-- TODO: <leader>q is used to quit
	-- buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	-- TODO: <leader>f is used to fuzzy search files
	-- buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local diagnostic_handler = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = false
	}
)

local print_markup_content = function(markup_content)
	local kind = markup_content.kind
	local value = markup_content.value
	print("kind", vim.inspect(kind), "\nvalue", vim.inspect(value))
end

local print_range = function(range)
	local start = range.start
	local start_line = start.line
	local start_char = start.character

	local eend = range["end"]
	local end_line = eend.line
	local end_char = eend.character

	print("start-line:char", start_line, ":", start_char, "end-line:char", end_line, ":", end_char)
end

local function merge(table1, table2)
	local new_table = {}
	for k, v in next, table1 do
		new_table[k] = v
	end
	for k, v in next, table2 do
		new_table[k] = v
	end
	return new_table
end

local function safe_parse_range(range)
	local start = range.start or {}
	local range_end = range["end"] or {}
	local start_line = start.line
	local start_char = start.character
	local end_line = range_end.line
	local end_char = range_end.character

	return {
		start = { line = start_line, character = start_char },
		["end"] = { line = end_line, character = end_char }
	}
end

local function map(func, array)
	local new_arr = {}
	for i, v in ipairs(array) do
		new_arr[i] = func(v, i)
	end
	return new_arr
end

local function mapn(func, ...)
	local new_arr = {}
	for i, _ in ipairs(arg) do
		local arg_list = (map(function (arr) return arr[i] end, arg))
		new_arr[i] = func(unpack(arg_list))
	end
end

local function reduce(reducer, input_table, acc)
	local acc = acc or {}
	for k, v in next, input_table do
		acc = reducer(acc, v, k)
	end
	return acc
end

local function find_on_screen_height(line_width, wrap_at)
	return math.max(1, math.ceil(line_width/wrap_at))
end

local function make_height_finder(wrap_at)
	return function(line_width)
		return find_on_screen_height(line_width, wrap_at)
	end
end

local function add(v1, v2) return v1 + v2 end

local default_border = {
  {"", "NormalFloat"},
  {"", "NormalFloat"},
  {"", "NormalFloat"},
  {" ", "NormalFloat"},
  {"", "NormalFloat"},
  {"", "NormalFloat"},
  {"", "NormalFloat"},
  {" ", "NormalFloat"},
}

local function get_border_size(opts)
	local border = opts and opts.border or default_border
	local height = 0
	local width = 0

	if type(border) == 'string' then
		local border_size = {none = {0, 0}, single = {2, 2}, double = {2, 2}, rounded = {2, 2}, solid = {2, 2}, shadow = {1, 1}}
		if border_size[border] == nil then
			error("floating preview border is not correct. Please refer to the docs |vim.api.nvim_open_win()|"
			.. vim.inspect(border))
		end
		height, width = unpack(border_size[border])
	else
		local function border_width(id)
			if type(border[id]) == "table" then
				-- border specified as a table of <character, highlight group>
				return vim.fn.strdisplaywidth(border[id][1])
			elseif type(border[id]) == "string" then
				-- border specified as a list of border characters
				return vim.fn.strdisplaywidth(border[id])
			end
			error("floating preview border is not correct. Please refer to the docs |vim.api.nvim_open_win()|" .. vim.inspect(border))
		end
		local function border_height(id)
			if type(border[id]) == "table" then
				-- border specified as a table of <character, highlight group>
				return #border[id][1] > 0 and 1 or 0
			elseif type(border[id]) == "string" then
				-- border specified as a list of border characters
				return #border[id] > 0 and 1 or 0
			end
			error("floating preview border is not correct. Please refer to the docs |vim.api.nvim_open_win()|" .. vim.inspect(border))
		end
		height = height + border_height(2)  -- top
		height = height + border_height(6)  -- bottom
		width  = width  + border_width(4)  -- right
		width  = width  + border_width(8)  -- left
	end

	return { height = height, width = width }
end

local function _make_floating_popup_size(contents, opts)
	local screen_width = api.nvim_win_get_width(0)
	local height = opts.height
	local width = opts.width or screen_width
	local max_width = opts.max_width or screen_width
	local max_height = opts.max_height
	local wrap_at = opts.wrap_at or screen_width
	local max_line_width = 0
	local line_widths = {}

	local border_width = get_border_size(opts).width

	for i, line in ipairs(contents) do
		line_widths[i] = vim.fn.strdisplaywidth(line)
		max_line_width = math.max(line_widths[i], max_line_width)
	end

	local effective_width = math.min(wrap_at, screen_width, max_line_width, max_width, width + border_width)
	local effective_wrap_at = effective_width
	local effective_height = height or reduce(add, map(make_height_finder(effective_wrap_at), line_widths), 0)

	return effective_width, effective_height
end

local function make_floating_popup_options(width, height, opts)
	local col = 0
	local row
	local anchor = ''
	local lines_above = vim.fn.winline() - 1
	local lines_below = vim.fn.winheight(0) - lines_above
	-- TODO: This isn't the exact width of the screen. It contains the width
	-- of the signs and number columns as well. Make this exact.
	local screen_width = api.nvim_win_get_width(0) -- api.nvim_get_option('columns')
	local cursor_x = vim.api.nvim_win_get_cursor(0)[2]

	if lines_above <= lines_below then
		anchor = anchor..'N'
		row = 1
		height = math.min(height, lines_below)
	else
		anchor = anchor..'S'
		row = -get_border_size(opts).height
		height = math.min(height, lines_above)
	end

	if cursor_x <= screen_width/2 then
		anchor = anchor..'W'
		if screen_width - cursor_x < width then
			col = (screen_width - cursor_x) - width
		end
	else
		anchor = anchor..'E'
		if cursor_x < width then
			col = width - (screen_width - cursor_x)
		end
	end

	return {
		anchor = anchor,
		col = col + (opts.offset_x or 0),
		height = height,
		focusable = opts.focusable,
		relative = 'cursor',
		row = row + (opts.offset_y or 0),
		style = 'minimal',
		width = width,
		border = opts.border or default_border,
	}
end

local function add_padding(contents, opts)
	if opts.pad_top then
		for _ = 1, opts.pad_top do
			table.insert(contents, 1, "")
		end
	end
	if opts.pad_bottom then
		for _ = 1, opts.pad_bottom do
			table.insert(contents, "")
		end
	end
	return contents
end

local function open_floating_preview(contents, syntax, opts)
	vim.validate {
		contents = { contents, 't' },
		syntax = { syntax, 's', true },
		opts = { opts, 't', true }
	}
	opts = opts or {}
	opts.wrap = opts.wrap ~= false
	opts.stylize_markdown = opts.stylize_markdown ~= false
	opts.close_events = opts.close_events or {"CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre"}

	local bufnr = api.nvim_get_current_buf()
	-- Check if another floating preview already exists for this buffer and
	-- close it if needed.
	local existing_float = npcall(api.nvim_buf_get_var, bufnr, "floating_preview")
	if existing_float and api.nvim_win_is_valid(existing_float) then
		api.nvim_win_close(existing_float, true)
	end

	local floating_bufnr = api.nvim_create_buf(false, true)
	contents = add_padding(contents, opts)

	if syntax then
		api.nvim_buf_set_option(floating_bufnr, 'syntax', syntax)
	end
	api.nvim_buf_set_lines(floating_bufnr, 0, -1, true, contents)

	local width, height = _make_floating_popup_size(contents, opts)
	local float_opts = make_floating_popup_options(width, height, opts)
	local floating_winnr = api.nvim_open_win(floating_bufnr, false, float_opts)


	api.nvim_win_set_option(floating_winnr, 'foldenable', false)
	api.nvim_win_set_option(floating_winnr, 'wrap', opts.wrap)

	api.nvim_buf_set_option(floating_bufnr, 'modifiable', false)
	api.nvim_buf_set_option(floating_bufnr, 'bufhidden', 'wipe')
	api.nvim_buf_set_keymap(floating_bufnr, "n", "q", "<cmd>bdelete<cr>", {silent = true, noremap = true})

	util.close_preview_autocmd(opts.close_events, floating_winnr)

	api.nvim_buf_set_var(bufnr, "floating_preview", floating_winnr)

	return floating_bufnr, floating_winnr
end

local function find_window_by_var(name, value)
	for _, win in ipairs(api.nvim_list_wins()) do
		if npcall(api.nvim_win_get_var, win, name) == value then
			return win
		end
	end
end

local hover_handler = function(_, method, result, _, _, config)
	local focus_id = method
	local horizontal_bar = "----"
	local config = config or {}
	if not (result and result.contents) then return end

	local markdown_lines = util.convert_input_to_markdown_lines(result.contents)

	-- The last line is the path of whatever we are hovering at is defined.
	-- We don't care about that, so remove it.
	table.remove(markdown_lines, #markdown_lines)
	-- Check if the last line is a horizontal bar. If so, remove it.
	if markdown_lines[#markdown_lines] == horizontal_bar then
		table.remove(markdown_lines, #markdown_lines)
	end
	markdown_lines = util.trim_empty_lines(markdown_lines)

	if vim.tbl_isempty(markdown_lines) then return end

	local win_height = api.nvim_get_option('lines')
	local win_width = api.nvim_get_option('columns')
	local max_height = math.max(math.ceil(win_height * 0.6), 35)
	local max_width = math.max(math.ceil(win_width * 0.6), 75)

	local opts = {
		max_width = max_width,
		max_height = max_height,
		focusable = true,
		pad_top = 1,
		pad_bottom = 1
	}

	local current_winnr = api.nvim_get_current_win()
	local current_bufnr = api.nvim_get_current_buf()

	-- Check if the current window is the floating preview, go to the
	-- previous window if that is the case.
	if npcall(api.nvim_win_get_var, current_winnr, focus_id) then
		api.nvim_command("wincmd p")
		return current_bufnr, current_winnr
	end
	-- If a floating window already is already open, jump to it
	do
		local win = find_window_by_var(focus_id, current_bufnr)
		if win and api.nvim_win_is_valid(win) and vim.fn.pumvisible() == 0 then
			api.nvim_set_current_win(win)
			api.nvim_command("stopinsert")
			return api.nvim_win_get_buf(win), win
		end
	end
	local bufnr, winnr = open_floating_preview(markdown_lines, "markdown", merge(config, opts))
	api.nvim_win_set_var(winnr, focus_id, current_bufnr)
	return bufnr, winnr
end

local servers = { "rust_analyzer", "clojure_lsp", "clangd", "dockerls" }

for _, server in ipairs(servers) do
	nvim_lsp[server].setup {
		on_attach = on_attach,
		handlers = {
			["textDocument/publishDiagnostics"] = diagnostic_handler,
			["textDocument/hover"] = hover_handler
		},
		flags = {
			debounce_text_changes = 150
		}
	}
end
