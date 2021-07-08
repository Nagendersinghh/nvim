let g:python3_host_prog = '/Users/nagender/.pyenv/versions/neovim3/bin/python'

if &compatible
  set nocompatible
endif

" Plugin settings ---------- {{{
" Add the dein installation directory into runtimepath
" Remove dein
call plug#begin()
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim', { 'depends': 'fzf' }

" Tags autoupdate
Plug 'ludovicchabant/vim-gutentags'

" git
Plug 'tpope/vim-fugitive'

" LSP
Plug 'neovim/nvim-lspconfig'

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
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-salve'
" call dein#add('venantius/vim-cljfmt')

" VimWiki
Plug 'vimwiki/vimwiki'

" Eye candy
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

Plug 'sonph/onehalf', { 'rtp': 'vim/' }
Plug 'nightsense/rusticated'
Plug 'nightsense/snow'
Plug 'nightsense/carbonized'

Plug 'UndeadLeech/vim-undead'

Plug 'vim-scripts/fountain.vim'
Plug 'vim-scripts/DrawIt'
Plug 'morhetz/gruvbox'

call plug#end()

" set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
" if dein#load_state('~/.cache/dein')
"   call dein#begin('~/.cache/dein')
" 
"   call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
"   " TODO: Remove deoplete to something that's currently in development
"   call dein#add('Shougo/deoplete.nvim')
"   if !has('nvim')
"     call dein#add('roxma/nvim-yarp')
"     call dein#add('roxma/vim-hug-neovim-rpc')
"   endif
"   call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
"   call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
" 
"   " Tags autoupdate
"   call dein#add('ludovicchabant/vim-gutentags')
" 
"   " Linting
"   " TODO: See if this is needed now that lsp support has landed
"   " call dein#add('dense-analysis/ale')
"   " git
"   call dein#add('tpope/vim-fugitive')
" 
"   " LSP Client
"   " call dein#add('autozimu/LanguageClient-neovim', {
"   "   \ 'rev': 'next',
"   "   \ 'build': 'bash install.sh',
"   "   \ })
"   " LSP
"   call dein#add('neovim/nvim-lspconfig')
" 
"   " js highlighting
"   " Try vim-jsx-improve for some time to see if it works properly
"   call dein#add('pangloss/vim-javascript')
"   call dein#add('maxmellon/vim-jsx-pretty')
"   call dein#add('dag/vim-fish')
" 
"   " Rust
"   call dein#add('rust-lang/rust.vim')
" 
"   call dein#add('tpope/vim-repeat')
"   call dein#add('guns/vim-sexp')
"   " Clojure plugins
"   call dein#add('tpope/vim-fireplace')
"   call dein#add('tpope/vim-salve')
"   " call dein#add('venantius/vim-cljfmt')
" 
"   " VimWiki
"   call dein#add('vimwiki/vimwiki')
" 
"   " Eye candy
"   " call dein#add('vim-airline/vim-airline')
"   " call dein#add('vim-airline/vim-airline-themes')
" 
"   call dein#add('sonph/onehalf', { 'rtp': 'vim/' })
"   call dein#add('nightsense/rusticated')
"   call dein#add('nightsense/snow')
"   call dein#add('nightsense/carbonized')
" 
"   call dein#add('UndeadLeech/vim-undead')
" 
"   call dein#add('vim-scripts/fountain.vim')
"   call dein#add('vim-scripts/DrawIt')
"   call dein#add('morhetz/gruvbox')
"   call dein#end()
"   call dein#save_state()
" endif

filetype plugin indent on
syntax enable

" if dein#check_install()
"   call dein#install()
" endif
" }}}

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

" LanguageClient-neovim configuration --------------- {{{
" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['rustup', 'run', 'stable', 'rls']
"     \}

" Don't open preview window when autocompleting
" set completeopt-=preview
" How much time to wait after `textDocument_didChange` is sent.
" let g:LanguageClient_changeThrottle = 0.5
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

" Keymappings
source ~/.config/nvim/keymappings.nvim

" LSP config
source ~/.config/nvim/lsp.nvim

" Source custom plugins
source ~/Documents/vimPlugins/fzf-grep.vim

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
colorscheme myCarbonizedDark
" colorscheme onehalfdark
" colorscheme onehalflight
" colorscheme gruvbox
" }}}

