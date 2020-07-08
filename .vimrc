" -- Plugins -------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" core
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'sheerun/vim-polyglot'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'psf/black', { 'branch': 'stable', 'for': 'python' }
" text object
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'bkad/CamelCaseMotion'
" enhancement
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Yggdroot/indentLine'
Plug 'Asheq/close-buffers.vim'
Plug 'justinmk/vim-sneak'
Plug 'mhinz/vim-startify'
Plug 'vimwiki/vimwiki', { 'on': [ 'VimwikiIndex', 'VimwikiMakeDiaryNote', 'VimwikiDiaryIndex' ] }
" status line
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
" themes plugins
Plug 'joshdick/onedark.vim'

call plug#end()

" -- General -------------------------------------------------------------------

set encoding=UTF-8
" set 256 color
set t_Co=256
" set terminal gui colors
set termguicolors
" Highlight cursor line
set cursorline
" syntax highlighting
syntax on
" allow hidden window
set hidden
" disable wrap and wrap when typing
set nowrap
" Display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5
" Highlight matching pairs of brackets. Use the '%' character to jump between pairs
set matchpairs+=<:>
" Set to auto read when a file is changed from the outside
set autoread
" increase the history limit of
set history=1000
" show buffer line
set showtabline=2
" disable mode display since lightline display
set noshowmode
" Fixes common backspace problems
set backspace=indent,eol,start

" line numbers
set number
set relativenumber
" indentation
set autoindent
set nostartofline
" No annoying sound on errors
set noerrorbells
set novisualbell

" Mode Settings for different cursor in different modes
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" search config
set ignorecase
set smartcase
set incsearch
set hlsearch

" Whitespace
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set textwidth=0
set formatoptions-=t

" auto commands
augroup FormatFile
  autocmd!
  " disable vim stupid format issue with comment
  autocmd BufEnter * set fo-=c fo-=r fo-=o
  " terminal remove linenumbers
  autocmd TermOpen * setlocal nonumber norelativenumber
  " Setting for python
  autocmd FileType, BufEnter python,doctest set ai ts=4 sw=4 sts=4 et
  autocmd BufWritePre *.py execute ':Black'
augroup end

" -- Color ---------------------------------------------------------------------

colorscheme onedark
" coc git highlight
hi CocGitChange ctermbg=NONE cterm=NONE ctermfg=Blue guifg=#61afef
hi CocGitAdd ctermbg=NONE cterm=NONE ctermfg=DarkGreen guifg=#98c379
hi CocGitDelete ctermbg=NONE cterm=NONE ctermfg=DarkRed guifg=#e06c75
" coc diagnostic highlight
hi CocErrorHighlight gui=bold guifg=#e06c75
hi CocWarningHighlight gui=NONE guifg=#e5c07b
" overwrite default vim diff highlight
hi DiffChange gui=NONE guifg=#2b2c34 guibg=#e5c07b
hi DiffText gui=NONE guifg=#2b2c34 guibg=#de9712
" floaterm hl groups
hi Floaterm guibg=#282c34
hi FloatermBorder guibg=NONE guifg=#61afef

" -- Plugin Config -------------------------------------------------------------

" force polyglot prevent indentline conceal markdown
let g:vim_markdown_conceal = 0

" disable netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" CamelCaseMotion config
let g:camelcasemotion_key = '<space>'

" vim-tmux-navigator config
let g:tmux_navigator_disable_when_zoomed = 1

" indent Line config
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_fileTypeExclude = ['coc-explorer', 'fzf', 'floaterm', 'vimwiki']
let g:indentLine_bufNameExclude = ["term:.*"]

" vim autoclose tag config
let g:closetag_filenames = '*.html,*.js'
let g:closetag_emptyTags_caseSensitive = 1

" spell whitelist file
set spellfile=~/.vim/spell/en.utf-8.add

" vim sneak config
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#absolute_dir = 1
let g:sneak#map_netrw = 0

" vimwiki
let g:vimwiki_list = [
  \ { 'path': '~/Documents/vimwiki/', 'syntax': 'markdown', 'ext': '.md' },
  \ { 'path': '~/Documents/vimwiki/docker', 'syntax': 'markdown', 'ext': '.md'},
  \ { 'path': '~/Documents/vimwiki/uni', 'syntax': 'markdown', 'ext': '.md'},
  \ { 'path': '~/Documents/vimwiki/database', 'syntax': 'markdown', 'ext': '.md'},
  \ ]
let g:vimwiki_table_mappings = 0
augroup WikiTemplate
  autocmd!
  au BufNewFile ~/Documents/vimwiki/diary/*.md :silent 0r !diarytemplate
augroup end

" -- Fzf -----------------------------------------------------------------------

let g:fzf_layout = { 'window': { 'width': 0.86, 'height': 0.83, 'highlight': "FloatermBorder" } }
let g:fzf_history_dir = '~/.local/share/fzf-history'

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--preview', 'head -50 {}']}, <bang>0)
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, '-p ~/.ignore', {'options': '--delimiter : --nth 4..'}, <bang>0)

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

" interactively delete buffer
command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

" Override statusline for fullscreen and down setting
function! s:fzf_statusline()
  highlight fzf1 guibg=#282c34
  setlocal statusline=%#fzf1#\ \ fzf
endfunction

augroup HideFzfBar
  autocmd!
  autocmd User FzfStatusLine call <SID>fzf_statusline()
augroup end

" -- Floaterm ------------------------------------------------------------------

" floaterm key maps and basic setup
let g:floaterm_keymap_toggle = '<C-f>'
let g:floaterm_keymap_new = '<leader>vv'
let g:floaterm_keymap_prev = '<leader>vp'
let g:floaterm_keymap_next = '<leader>vn'
let g:floaterm_position = 'center'
let g:floaterm_width = 0.85
let g:floaterm_height = 0.8
let g:floaterm_autoclose=2

" display line number, remove terminal from buffer list on term buffer enter
function s:floatermSettings()
    setlocal nobuflisted
endfunction

augroup TerminalHide
  autocmd!
  autocmd FileType floaterm call s:floatermSettings()
augroup end

" custom function to display all floating terminal
function! TermList() abort
  " get all floating terminal
  let l:bufs = floaterm#buflist#gather()
  if len(bufs) < 1
    echo 'NONE'
  endif
  let l:termlist = []
  for bufnr in bufs
    " getbufinfo from vim api
    let l:bufinfo = getbufinfo(bufnr)[0]
    let l:name = bufinfo['name']
    " get terminal title from vim api
    let l:title = getbufvar(bufnr, 'term_title')
    let l:line = string(bufnr) . '  ' . name . '  ' . title
    echo line
  endfor
endfunction

" -- Startify ------------------------------------------------------------------

let g:startify_lists = [
  \ { 'type': 'sessions',  'header': ['   Sessions']  },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
  \ { 'type': 'commands',  'header': ['   Commands']  },
  \ ]

let g:startify_bookmarks = [
  \ { 'A': '~/.config/alacritty/alacritty.yml' },
  \ { 'B': '~/.bashrc' },
  \ { 'C': '~/.config/nvim/coc-settings.json' },
  \ { 'F': '~/.config/vifm/vifmrc' },
  \ { 'S': '~/.config/skhd/skhdrc' },
  \ { 'T': '~/.tmux.conf' },
  \ { 'V': '~/.vimrc' },
  \ { 'Y': '~/.config/yabai/yabairc' },
  \ { 'Z': '~/.zshrc' },
  \ ]

let g:startify_commands = [
  \ { 'f': [ 'Vifm', ':enew | FloatermNew vifm' ] },
  \ { 'w': [ 'Vimwiki', ':VimwikiIndex' ] },
  \ { 'd': [ 'Diary', 'VimwikiMakeDiaryNote' ] }
\ ]

let g:startify_change_to_dir = 0
let g:startify_fortune_use_unicode = 1
let g:startify_enable_special = 0

" -- Lightline -----------------------------------------------------------------

" lightline components
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'active': {
  \   'left': [
  \     ['mode', 'paste'],
  \     ['gitbranch', 'filename', 'readonly'],
  \     ['cocstatus']
  \   ],
  \   'right':[
  \     ['lineinfo'],
  \     ['cocdiagnostic', 'filetype'],
  \     ['gitstatus']
  \   ],
  \ },
  \ 'inactive': {
  \   'left': [
  \     ['gitbranch', 'filename'],
  \   ],
  \   'right':[
  \     ['lineinfo'],
  \     ['filetype']
  \   ],
  \ },
  \ 'tabline': {
  \   'left': [
  \     ['buffers']
  \   ],
  \ 'right': [
  \     ['vimcons'],
  \   ],
  \ },
  \ 'component': {
  \   'vimcons': '',
  \ },
  \ 'component_function': {
  \   'cocstatus': 'LightlineCocStatus',
  \   'cocdiagnostic': 'LightlineCocDiagnostic',
  \   'gitstatus': 'LightlineGitStatus',
  \   'gitbranch': 'LightlineGitBranch',
  \   'lineinfo': 'LightlineLineInfo',
  \   'filename': 'LightlineFilename',
  \ },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers',
  \   'readonly': 'LightLineReadonly',
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel',
  \   'readonly': 'warning',
  \ },
  \ 'mode_map': {'c': 'NORMAL'},
  \ }

" coc status information
function! LightlineCocStatus() abort
  if (winwidth(0) < 40)
    return ''
  endif
  let msg = get(g:, 'coc_status', '')
  return trim(msg)
endfunction

" coc lint information
function! LightlineCocDiagnostic() abort
  if (winwidth(0) < 40)
    return ''
  endif
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return ' ' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, ' ' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, ' ' . info['warning'])
  endif
  return join(msgs, ' ') == '' ? ' ' : join(msgs, ' ')
endfunction

" display lock symbol for readonly file
function! LightLineReadonly()
  if (winwidth(0) > 40)
    return &readonly ? '' : ''
  endif
  return ''
endfunction

" display branch detail
function! LightlineGitBranch()
  if (winwidth(0) > 40)
    let branch = get(g:, 'coc_git_status', '')
    return branch
  endif
  return ''
endfunction

" display file name with edit check
function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return winwidth(0) > 40 ? filename . modified : ''
endfunction

" display coc git modify detail +1 ~1 -1 etc
function! LightlineGitStatus() abort
  let status = get(b:, 'coc_git_status', '')
  return winwidth(0) > 120 ? status : ''
endfunction

" line no indicator symbols
let g:line_no_indicator_chars = ['⎺', '⎻', '─', '⎼', '⎽']

" display lineNoIndicator (from drzel/vim-line-no-indicator)
function! LineNoIndicator() abort
  let l:current_line = line('.') - 1
  let l:total_lines = line('$') - 1
  if l:current_line == 0
    let l:index = 0
  elseif l:current_line == l:total_lines
    let l:index = -1
  else
    let l:line_no_fraction = floor(l:current_line) / floor(l:total_lines)
    let l:index = float2nr(l:line_no_fraction * len(g:line_no_indicator_chars))
  endif
  return g:line_no_indicator_chars[l:index]
endfunction

" change the display of line info
function! LightlineLineInfo() abort
  return winwidth(0) > 40 ? LineNoIndicator() . ' ' . line('.') . '/' . line('$') : ''
endfunction

" use powerline symbols
let g:lightline.separator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
	\   'left': '', 'right': ''
  \}

" lightline bufferline config
let g:lightline#bufferline#show_number  = 2
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#number_map = {
\ 0: '₀', 1: '₁', 2: '₂', 3: '₃', 4: '₄',
\ 5: '₅', 6: '₆', 7: '₇', 8: '₈', 9: '₉'}
let g:lightline#bufferline#unicode_symbols = 1

" overwrite the lightline onedark theme
let s:palette = g:lightline#colorscheme#onedark#palette
let s:palette.inactive.middle = [ [ '#282c34', '#282c34', 235, 113, 'NONE' ] ]
unlet s:palette

" -- Coc -----------------------------------------------------------------------

" coc config see coc github
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set signcolumn=yes
set shortmess+=c

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" coc pairs
augroup CocPairs
  autocmd!
  autocmd FileType markdown let b:coc_pairs_disabled = ['`', "'"]
  autocmd FileType vim,vifm let b:coc_pairs_disabled = ['"']
  autocmd FileType python let b:coc_pairs_disabled = ['"']
augroup end

" multi cursors
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

" coc prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" -- Custom commands -----------------------------------------------------------

" ctrl semicolumn like vscode ctrl semicolumn
" iterm2 map 'cmd ;' to :CtrlSemicolumn
command! CtrlSemicolumn normal maA;<Esc>`a
command! CtrlColumn normal maA,<Esc>`a

" -- Key maps ------------------------------------------------------------------

" make Y work as D
map Y y$
" yank to clipboard in visual mode
vmap Y "*y
" disable ex mode
nnoremap Q q

" use arrow to resize vim split
nnoremap <Up> <C-w>3+
nnoremap <Down> <C-w>3-
nnoremap <right> <C-w>3>
nnoremap <left> <C-w>3<

" switch buffer
nnoremap <silent> <S-right> :bn<CR>
nnoremap <silent> <S-left> :bp<CR>

" reselect the pasted text
noremap gV `[v`]

" scroll 3 times faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" set spell
nnoremap <leader>s :set spell!<CR>

" quickfix list
nnoremap <leader>q :cclose<CR>
nnoremap <leader>j :cn<CR>
nnoremap <leader>k :cp<CR>

" make a buffer into unlisted buffer (e.g. terminal may want to unlisted)
nnoremap <leader>u :setlocal nobuflisted<CR>
nnoremap <leader>vl :call TermList()<CR>
nnoremap <leader>vg :FloatermNew lazygit<CR>
inoremap <silent> <C-f> <C-o>:FloatermToggle<CR>

" cgn motion map
nnoremap <leader>rs *Ncgn

" startify
nnoremap <leader>a :Startify<CR>

" fzf.vim mappings
nnoremap <C-p> :Files<CR>
nnoremap <C-m> :Buffers<CR>
nnoremap <leader>g :Ag<CR>
nnoremap <leader>l :GFiles?<CR>
nnoremap <leader>m :Marks<CR>

" coc multi cursor
nmap <expr> <silent> <C-g> <SID>select_current_word()
nmap <silent> <C-q> <Plug>(coc-cursors-position)

" Remap keys for gotos(coc)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word(coc)
nmap <leader>rn <Plug>(coc-rename)

" coc git key map
nmap [h <Plug>(coc-git-prevchunk)
nmap ]h <Plug>(coc-git-nextchunk)
nmap <leader>hp <Plug>(coc-git-chunkinfo)
nmap <leader>hc <Plug>(coc-git-commit)
nmap <leader>hu :CocCommand git.chunkUndo<CR>
nmap <leader>hs :CocCommand git.chunkStage<CR>
nmap <leader>hf :CocCommand git.foldUnchanged<CR>

" create text object for git chunks
omap ih <Plug>(coc-git-chunk-inner)
xmap ih <Plug>(coc-git-chunk-inner)
omap ah <Plug>(coc-git-chunk-outer)
xmap ah <Plug>(coc-git-chunk-outer)

" coc list map
nnoremap <leader>c :CocList commands<CR>
nnoremap <leader>y :CocList -A --normal yank<CR>

" coc engine restart
nnoremap <leader>e :CocRestart<CR>

" coc prettier map
vmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" coc snippets
vmap <C-s> <Plug>(coc-snippets-select)
imap <C-s> <Plug>(coc-snippets-expand-jump)

" cancel hightlight of the word
nnoremap <leader>n :noh<CR>

" buffers (t as tab in other app or buffer in vim)
" close buffer without closing affecting other splits and moving to next buffer
nnoremap <silent> <leader>tc :bp\|bd #<CR>
" to next buffer
nnoremap <silent> <leader>tn :bn<CR>
nnoremap <silent> <leader>tp :bp<CR>

" close buffer custom mapping
nnoremap <silent> <leader>th :Bdelete hidden<CR>
nnoremap <silent> <leader>ta :Bdelete all<CR><C-w>h
nnoremap <silent> <leader>tu :Bdelete! nameless<CR>
nnoremap <silent> <leader>ts :BD<CR>
nnoremap <silent> <leader>to :Bdelete other<CR>
" list all bufferes and enter number
nnoremap <leader>tt :ls<CR>:b<space>

" coc hover show details
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" light line buffer line jump mapping
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)