require'nvim-treesitter.configs'.setup {
	-- one of "all", "maintained" (parsers with maintainers), or a list of languages
	ensure_installed = {"c", "rust", "fish", "javascript", "lua"}, 
	highlight = {
		enable = true,              -- false will disable the whole extension
		disable = {}
	},
}
