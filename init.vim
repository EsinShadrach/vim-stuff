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

let g:tagalong_verbose = 1
function SetTitle()
  let &titlestring = expand('%:t').' - NVIM'
endfunction

autocmd BufEnter,BufWritePost * call SetTitle()

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
  Plug 'vim-python/python-syntax'
  Plug 'voldikss/vim-floaterm'
  Plug 'lukas-reineke/indent-blankline.nvim'
call plug#end()

nnoremap ff :Rg<CR>
" Start Screen Config

" The `<c-u>` removes the current visual mode, so a function can be called
xnoremap <buffer> p :<c-u>call <SID>Paste()<cr>

" The <SID> above is the same as the s: here
function! s:Paste()
  call tagalong#Trigger()

  " gv reselects the previously-selected area, and then we just paste
  normal! gvp

  call tagalong#Apply()
endfunction


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
       \ startify#pad(split(system('figlet -w 120 R A F E'), '\n'))

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

let g:coc_settings = {
    \ "coc-tailwindcss.enable": "true",
    \ "coc-tailwindcss.emmetCompletions": "true",
    \ "coc-tailwindcss.showClassSuggestions.enabled": "true",
    \ "coc-tailwindcss.showClassSuggestions.classNames": "[]",
    \ "coc-tailwindcss.cssLanguages": [ "css", "less", "postcss", "sass", "scss", "stylus", "vue" ],
    \ "coc-tailwindcss.jsLanguages": [ "javascript", "javascriptreact", "reason", "typescriptreact" ],
    \ "coc-tailwindcss.htmlLanguages": [ "blade", "edge", "eelixir", "ejs", "elixir", "elm", "erb", "eruby", "haml", "handlebars", "htmldjango", "html", "HTML (EEx)", "HTML (Eex)", "html.twig", "jade", "leaf", "markdown", "njk", "nunjucks", "php", "razor", "slim", "svelte", "twig", "vue" ],
    \ }


" Configuration for dashboard-nvim

let g:material_theme_style = 'ocean'
let g:material_terminal_italics = 1
let g:material_italic_comments = 1
let g:material_italic_keywords = 1
let g:material_italic_functions = 1
let g:material_italic_variables = 1
let g:material_italic_strings = 1
let g:material_italic_builtins = 1
colorscheme material

let g:wakatime_api_key = "waka_ddef1c0d-0dd1-45b7-92be-de10c918d66b"

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

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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

" Enable the display of special characters for whitespace and EOL
set list
" Configure listchars to display space as ⋅ and EOL as ↴
set listchars+=space:⋅
set listchars+=eol:↴

" Configure the "indent-blankline.nvim" plugin
lua << EOF
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
EOF

