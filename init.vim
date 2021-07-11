let g:python3_host_prog = '/Users/nagender/.pyenv/versions/neovim3/bin/python'

if &compatible
  set nocompatible
endif

" Plugin settings ---------- {{{
call plug#begin()

Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim', { 'depends': 'fzf' }

Plug 'hrsh7th/nvim-compe'

" Tags autoupdate
Plug 'ludovicchabant/vim-gutentags'

" git
Plug 'tpope/vim-fugitive'

" LSP
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Update the parsers on update

" js highlighting
" Try vim-jsx-improve for some time to see if it works properly
" Plug 'pangloss/vim-javascript'
" Plug 'maxmellon/vim-jsx-pretty'
Plug 'dag/vim-fish'

" Rust
Plug 'rust-lang/rust.vim'

Plug 'tpope/vim-repeat'
Plug 'guns/vim-sexp'
" Clojure plugins
" TODO: Try conjure
" vim-iced (Seems heavy)
" vim-acid (Needs python)
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-salve'
" call dein#add('venantius/vim-cljfmt')

" VimWiki
Plug 'vimwiki/vimwiki'

" Eye candy
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

Plug 'arcticicestudio/nord-vim'
Plug 'sonph/onehalf', { 'rtp': 'vim/' }
Plug 'nightsense/rusticated'
Plug 'nightsense/snow'
Plug 'nightsense/carbonized'

Plug 'UndeadLeech/vim-undead'

Plug 'vim-scripts/fountain.vim'
Plug 'vim-scripts/DrawIt'
Plug 'morhetz/gruvbox'
Plug 'monsonjeremy/onedark.nvim'

" Plugins in development
" Plug '~/Documents/vimPlugins/whid'

call plug#end()

" }}}

filetype plugin indent on
syntax enable

" Source custom functions & commands
source ~/.config/nvim/customCommands.nvim

" Vimwiki Configuration -------------- {{{
" Don't consider other markdown files as wikis
let g:vimwiki_global_ext = 0
let markdown_wiki = {'path': '~/Documents/wiki_markdown/',
            \ 'syntax': 'markdown',
            \ 'ext': '.md',
            \ 'custom_wiki2html': 'vimwiki-markdown-to-html',
            \ 'template_path': '~/Documents/wiki/templates/',
            \ 'template_default': 'default_template',
            \ 'template_ext': '.html',
            \ 'auto_export': 1}
let main_wiki = {'path': '~/Documents/wiki/',
            \ 'template_path': '~/Documents/wiki/templates/',
            \ 'template_default': 'default_template',
            \ 'template_ext': '.html',
            \ 'name': 'Main',
            \ 'auto_export': 1,
            \ 'css_name': 'fira_go_style.css'}
let g:vimwiki_list = [main_wiki, markdown_wiki]
" vim inside tmux fucks up the terminal if it detects unicode characters.
" Disabling the more fancy stuff until I find a solution for it.
" let g:vimwiki_listsyms = ' oO✔︎'
" let g:vimwiki_listsym_rejected = '✗'
" }}}

" Deoplete Configuration ------------- {{{
let g:deoplete#enable_at_startup = 1
" }}}

" FZF configuration ------------ {{{
let g:fzf_action = {
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-x': 'split',
	\ 'alt-v': 'vsplit' }
" }}}

" Fugitive configuration ---------- {{{
let g:fugitive_force_bang_command = 1
" }}}

" Cljfmt configuration ------------ {{{
" let g:clj_fmt_autosave = 0
" }}}

" Basic Settings --------------- {{{

" Show when gutentags is generating the tags.
" set statusline+=%{gutentags#statusline()}
set relativenumber
set number
" Enable to switch buffers without saving
set hidden
" Enable project wise config files
set exrc
set ignorecase smartcase
" Set fish to be the default shell
set shell=/usr/local/bin/fish
" Set a color column at column 80
set colorcolumn=80
" Highlight current line
set cursorline
" Use system clipboard as the default registers for delete, yank and put
set clipboard=unnamed
" Don't wrap long lines, let it scroll.
set nowrap
set sidescroll=10
" Time to highlight the matching paren
set matchtime=10
" Open splits on the right
set splitright

" Shorten the "Hit ENTER to continue" message
set shortmess=a
" Shows in realtime what changes ex command should make. (Neovim only)
set inccommand=nosplit
" Thesaurus file
" set thesaurus+=~/.config/nvim/thesaurus.txt
" }}}

" Common typo fixes --------------------- {{{
:abbreviate tihs this
:abbreviate thsi this
:abbreviate tshi this
:abbreviate teh the
:abbreviate hlep help
:abbreviate lhep help
:abbreviate csont const
:abbreviate cosnt const
:abbreviate markdonw markdown
" }}}

" Useful abbreviations ------------------ {{{
:abbreviate lorem Lorem ipsum dolor sit amet, consectetur
            \ adipiscing elit. Vivamus ac neque fermentum,
            \ congue elit sed, gravida risus. Pellentesque semper
            \ luctus varius. Nunc ullamcorper sagittis ultrices.
            \ Vivamus lobortis ut sem at egestas. Nulla congue nisi
            \ id odio volutpat pulvinar. Ut vitae rhoncus diam.
            \ In at facilisis magna, in scelerisque velit. Suspendisse
            \ magna nulla, euismod quis dolor ut, sollicitudin commodo enim.
            \ In hac habitasse platea dictumst. Pellentesque vitae nisl rutrum,
            \ accumsan odio blandit, fringilla eros. Suspendisse laoreet
            \ gravida eros, a pellentesque augue congue gravida.
            \ Cras sit amet justo nisi. Nunc quis bibendum neque.
            \ Proin tempus ipsum sed egestas vulputate. Phasellus malesuada
            \ massa nec sem pretium sagittis. Suspendisse nec arcu non massa
            \ semper dignissim.
" }}}

" Compe setup (Autocomplete) ---------- {{{
lua << EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF
" }}}

" Keymappings
source ~/.config/nvim/keymappings.nvim

set runtimepath-=~/.config/nvim/lua
set runtimepath+=~/.config/nvim/lua
lua require("lsp_config")
lua require("treesitter_config")

" Source custom plugins
source ~/Documents/vimPlugins/fzf-grep.vim

" Lua plugin
source ~/Documents/vimPlugins/whid/whid.vim

" Statusline configuration ---------- {{{
" TODO: Use lua to create a plugin that configures the statusline
" set statusline=%f   " File path
" set statusline=%{Statusline()}
" }}}

" Theme Settings --------------- {{{
" Set airline theme
" let g:airline_theme='base16'

set termguicolors
" colorscheme lucius
" colorscheme mysticaltutor
" colorscheme elit
" colorscheme rusticated
" colorscheme snow
" colorscheme carbonized-light
" colorscheme carbonized-dark
" colorscheme myCarbonizedDark
" colorscheme onehalfdark
" colorscheme onehalflight
" colorscheme gruvbox
" Vim Script
colorscheme onedark
" colorscheme nord

" }}}

