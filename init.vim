set mouse=a
set number
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set title
set list
set listchars+=space:⋅
set listchars+=eol:↴
set termguicolors
set termguicolors
set background=dark
set relativenumber

let g:tagalong_verbose = 1

function SetTitle()
  let &titlestring = expand('%:t').' - NVIM'
endfunction

autocmd BufEnter,BufWritePost * call SetTitle()

nnoremap ff :Rg<CR>

" The `<c-u>` removes the current visual mode, so a function can be called
xnoremap <buffer> p :<c-u>call <SID>Paste()<cr>

" The <SID> above is the same as the s: here
function! s:Paste()
  call tagalong#Trigger()

  " gv reselects the previously-selected area, and then we just paste
  normal! gvp

  call tagalong#Apply()
endfunction

call plug#begin('~/.config/nvim/plugged')
  Plug 'kaicataldo/material.vim', { 'branch': 'main' }
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'mattn/emmet-vim'
  Plug 'tpope/vim-fugitive'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}
  Plug 'jiangmiao/auto-pairs'
  Plug 'ap/vim-css-color',
  Plug 'dart-lang/dart-vim-plugin'
  Plug 'vim-airline/vim-airline'
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'airblade/vim-rooter'
  Plug 'joshdick/onedark.vim'
  Plug 'tpope/vim-commentary'
  Plug 'mhinz/vim-startify'
  Plug 'git@github.com:wakatime/vim-wakatime.git'
  Plug 'andrewradev/tagalong.vim'
  Plug 'tpope/vim-surround'
  Plug 'voldikss/vim-floaterm'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'jbgutierrez/vim-better-comments'
  Plug 'rust-lang/rust.vim'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
call plug#end()

function! s:gitModified()
  let files = systemlist('git ls-files -m 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
  let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" Read ~/.NERDTreeBookmarks file and takes its second column
function! s:nerdtreeBookmarks()
  let bookmarks = systemlist("cut -d' ' -f 2- ~/.NERDTreeBookmarks")
  let bookmarks = bookmarks[0:-2] " Slices an empty last line
  return map(bookmarks, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_custom_header =
       \ startify#pad(split(system('figlet "R A F E    -    E S I N"'), '\n'))

let g:startify_lists = [
    \ { 'type': function('s:nerdtreeBookmarks'), 'header': ['   ~Bookmarks']},
    \ { 'type': 'files',     'header': ['   ~Recent Files']            },
    \ { 'type': 'dir',       'header': ['   '. getcwd()] },
    \ { 'type': 'sessions',  'header': ['   ~Sessions']       },
    \ { 'type': 'bookmarks', 'header': ['   ~Bookmarks']      },
    \ { 'type': function('s:gitModified'),  'header': ['   ~git modified']},
    \ { 'type': function('s:gitUntracked'), 'header': ['   ~git untracked']},
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

if (has('nvim'))
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

if (has('termguicolors'))
  set termguicolors
endif

" Define a custom leader key
let mapleader = ","

" Open NERDTree with leader key mapping
nmap <Leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden=1 " Show hidden files by default
let NERDTreeIgnore=['\.git$', '\.swp$']
" Automatically create a NERDTree bookmark for the current directory when opening a directory
autocmd BufEnter,DirChanged * if isdirectory(expand('%')) | NERDTree | execute 'Bookmark' | NERDTreeToggle | endif
" Enable nerdtree-git-plugin
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Ignored"   : "☒",
    \ "Unknown"   : "?"
    \ }

" Configuration for dashboard-nvim

let g:material_theme_style = 'ocean-community'
let g:material_terminal_italics = 1
let g:material_italic_comments = 1
let g:material_italic_keywords = 1
let g:material_italic_functions = 1
let g:material_italic_variables = 1
let g:material_italic_strings = 1
let g:material_italic_builtins = 1
colorscheme material

let g:wakatime_api_key = "waka_321ab25a-127b-4172-a950-685ea1f675e6"

" COC Commands
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume lates= coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Autocmd for Saving Files
autocmd BufWritePost * call CocFormat()

" Mapping for Ctrl + P
nnoremap <c-p> :call CocFormat()<CR>

" Custom function to run appropriate formatting command
function! CocFormat() abort
  if &filetype == 'dart'
      :DartFmt
   else
      CocCommand prettier.forceFormatDocument
  endif
endfunction

" Map Shift + Alt + O to run the organizeImport command
nmap <S-A-O> :CocCommand editor.action.organizeImport<CR>


" Toggle the floaterm with F12 (you can use any key binding you prefer)
nnoremap <F12> :FloatermToggle<CR>

" Open a new floaterm with the default shell
nnoremap <F9> :FloatermNew<CR>

" Open a new floaterm with a specific shell (e.g., bash)
nnoremap <F10> :FloatermNew bash<CR>
tnoremap <C-w>q <C-\><C-n>:q<CR>


" Enable Vim-Rooter
let g:rooter_manual_only = 1 " Only change the working directory manually
let g:rust_clip_command = 'xclip -selection clipboard'

" Markdown stuff
" set to 1, nvim will open the preview window after entering the Markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when changing
" from Markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, Vim will refresh Markdown when saving the buffer or
" when leaving insert mode. Default 0 is auto-refresh Markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be used for all files,
" by default it can be use in Markdown files only
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, the preview server is available to others in your network.
" By default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page.
" Useful when you work in remote Vim and preview on local browser.
" For more details see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" for path with space
" valid: `/path/with\ space/xxx`
" invalid: `/path/with\\ space/xxx`
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page URL in command line when opening preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom Vim function name to open preview page
" this function will receive URL as param
" default is empty
let g:mkdp_browserfunc = ''

" options for Markdown rendering
" mkit: markdown-it options for rendering
" katex: KaTeX options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: whether to disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: means the cursor position is always at the middle of the preview page
"   top: means the Vim top viewport always shows up at the top of the preview page
"   relative: means the cursor position is always at relative positon of the preview page
" hide_yaml_meta: whether to hide YAML metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

" use a custom Markdown style. Must be an absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style. Must be an absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or empty for random
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" set default theme (dark or light)
" By default the theme is defined according to the preferences of the system
let g:mkdp_theme = 'dark'

" combine preview window
" default: 0
" if enable it will reuse previous opened preview window when you preview markdown file.
" ensure to set let g:mkdp_auto_close = 0 if you have enable this option
let g:mkdp_combine_preview = 0

" auto refetch combine preview contents when change markdown buffer
" only when g:mkdp_combine_preview is 1
let g:mkdp_combine_preview_auto_refresh = 1

" normal/insert
<Plug>MarkdownPreview
<Plug>MarkdownPreviewStop
<Plug>MarkdownPreviewToggle

" example
nmap <M-s> <Plug>MarkdownPreview
" nmap <C-s> <Plug>MarkdownPreview
" nmap <C-p> <Plug>MarkdownPreviewToggle
" nmap <M-s> <Plug>MarkdownPreviewStop
