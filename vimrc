set nocompatible                " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set esckeys                     " allow usage of curs keys within insert mode
set ttm=100

syn on
set encoding=utf-8
set background=dark
set incsearch                   " Incremental search
set hlsearch                    " hilight search
set ai
set hidden                      " allow to cycle and hide modified buffers
set viminfo='1000,/1000,:1000,<1000,@1000,n~/.viminfo
set history=1000
set re=1
let g:plug_window = 'above topleft new'
call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'cespare/vim-toml'
"    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    " Initialize plugin system
call plug#end()
highlight! link NERDTreeFlags NERDTreeDir
let g:go_template_autocreate = 0
set tags=tags;/,.tags;/,TAGS;/
exe "set path=." . system("echo | cpp -v 2>&1 | grep '^ .*/include' | tr -d \"\n\" | tr \" \" \",\"")
set path+=.;/

set laststatus=2                " show status line?  Yes, always!
if v:version >= 703
"    set cursorline
if &term =~ '^xterm\|^rxvt.*'
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
  let &t_SI = "\e[3 q"
  let &t_SR = "\e[1 q"
  let &t_EI = "\e[4 q"
endif

" activate undofile, put all the files into the same directory
" Don't use it for tmp files
set undofile
set undodir=~/.cache/vim/bkp
au BufWritePre /tmp/* setl noundofile

endif

set listchars=tab:\ \ ,trail:-,extends:>,nbsp:█,precedes:<
set list
set virtualedit+=block
set wildchar=<TAB>
set wildmenu
set modeline
set modelines=5
set wildmode=longest,full

set clipboard=unnamed          "used klipper for paste
set grepprg=git\ grep\ -n

augroup tw_auto_commands
    autocmd!
    autocmd InsertEnter * highlight OverLength cterm=bold,underline ctermbg=black ctermfg=NONE
    autocmd OptionSet textwidth call OverHighlight()
    autocmd VimEnter * call OverHighlight()
    autocmd InsertLeave * highlight OverLength cterm=bold ctermbg=black ctermfg=yellow
augroup end
function! OverHighlight()
    if &l:buftype ==# 'help'
        return
    endif
    if exists("g:overlengthmatch")
        call matchdelete(g:overlengthmatch)
    endif
    if &textwidth > 0
        let g:overlengthmatch = matchadd('OverLength', '\%>'.&tw.'v.\+', -1)
    endif
endfunction

au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

au BufWinEnter *   syn match ErrorMsg "\%u00A0"
let loaded_matchparen = 1

filetype plugin indent on

au FileType php  set et sts=4 sw=4 nowrap
au FileType python  set et sts=4 sw=4 nowrap
au FileType html set et sts=4 sw=4 syntax=php nowrap
au FileType java set et sts=4 sw=4 nowrap
au FileType c set et sts=4 sw=4 tw=80 nowrap
au FileType cpp set et sts=4 sw=4 tw=80 nowrap
au FileType javascript set et sts=2 sw=2 nowrap
au FileType html,xhtml,xml setlocal sw=2 syntax=smarty nowrap
au FileType css  set et sts=4 sw=4 nowrap
au FileType sql  set et sts=4 sw=4 nowrap
au FileType actionscript  set et sts=4 sw=4 nowrap
au FileType go set noet ts=4 nolist tw=80 nowrap
au FileType make set noexpandtab shiftwidth=8 softtabstop=0 nolist nowrap
let g:linuxsty_patterns = [ "/usr/src/", "/linux", "/home/aurelienl/dev/util-linux/" ]
au BufRead,BufNewFile *.blk,*.fc setf c
au BufRead,BufNewFile *.blkk setf cpp
let c_gnu=1
let c_space_errors=1
let c_no_curly_errors=1

" IOP
au BufRead,BufNewFile *.iop setf d
set et sts=4 sw=4
hi MatchParen   cterm=underline  ctermfg=NONE       ctermbg=NONE
"command -nargs=+ Fds :cexpr system('fds -w <q-args>')
let g:bufExplorerFindActive=0
set pastetoggle=<F4>
noremap <F1>   :nohls<cr>
map! <F1>  <C-o>:nohls<cr>
map <F2> <C-]>
map g<F2> g<C-]>
map <C-Left> <C-w><Left>
map! <C-Left> <Esc> <C-w><Left>
if &term == "rxvt-unicode"
    map Oc <C-w><Right>
    map! Oc <Esc><C-w><Right>
    map Od <C-w><Left>
    map! Od <Esc><C-w><Left>
    map Ob  <C-w><Down>
    map! Ob  <C-w><Esc><Down>
    map Oa  <C-w><Up>
    map! Oa  <C-w><Esc><Up>
endif
map <C-Right> <C-w><Right>
map! <C-Right>  <Esc> <C-w><Right>
map <C-Up> <C-w><Up>
map! <C-Up> <Esc> <C-w><Up>
map <C-Down> <C-w><Down>
map! <C-Down>  <Esc> <C-w><Down>
map <F3> :NERDTree<cr>
map! <F3> <Esc>:NERDTree<cr>
map <F4> :gr! -w <cword><cr>
" spell check
map <F5> :setlocal spell! spelllang=en_us<CR>
map <S-F5> z=
map <F6> ma
map <F7> `a
map <F8> :GoImports<CR>
map <S-F8> :JavaImportOrganize<CR>
map [32~ :JavaImportOrganize<CR>
map <F9> :vsplit<cr>
map <F10> :vsplit<cr>:bn<cr>
"set makeprg=LC_ALL=C\ unbuffer\ make
map <F11> :make<cr>
autocmd FileType java no <F11> :make clean install<cr>
autocmd FileType java no <F2> :JavaSearch<cr>
au FileType java set makeprg=PYTHONUNBUFFERED=1\ rainbow\ --config=mvn3\ --\ mvn\ $*
au FileType pom  set makeprg=PYTHONUNBUFFERED=1\ rainbow\ --config=mvn3\ --\ mvn\ $*
autocmd FileType go no <F11> :GoRun<cr>
map <F12> mcHmh:%s/ \+$//ge<cr>'hzt`c

" next compilation error
map +        :cnext<cr>
map <kPlus>  :cnext<CR>
" previous compilation error
map -        :cprev<cr>
map <kMinus> :cprev<CR>
" next syntastic error
map <S-Right> :lnext<cr>
" previous syntastic error
map <S-Left> :lprev<cr>
map \| :Tab/\|<cr>
au QuickFixCmdPost [^l]* nested cwindow
au QuickFixCmdPost    l* nested lwindow

nnoremap \s ea<C-X><C-S>
"map! <PageUp> 25<Up>
"map <PageUp> 25<Up>
"map! <PageDown> 25<Down>
"map <PageDown> 25<Down>
" {{{ Tab Key magic ...
vmap <tab> >gv
vmap <bs> <gv
function! DeleteBuffer()
   let bid = bufnr("%")
   bnext
   exe "bdel " . bid
   redraw
endfunction
map bc :call DeleteBuffer()<cr>
function! TabAlign()
    let col  = col('.')
    let lnum = line('.')

    while lnum > 1
        let lnum = lnum - 1
        let ln = strpart(getline(lnum), col-1)
        let ms = matchstr(ln, '[^ ]*  *[^ ]')
        if ms != ""
            break
        endif
    endwhile

    if lnum == 1
        return "\<Tab>"
    else
        let @z = substitute(strpart(ms, 0, strlen(ms)-1), '.', ' ', 'g')
        if col > strlen(getline('.'))
            return "\<C-O>\"zp"
        else
            return "\<C-O>\"zP"
        endif
    endif

endfunction

function! CleverTab()
    let c = strpart(getline('.'), col('.')-2, 1)
    echom c
    if c == '' || c == '	' || c == ' ' || c == '    ' || c == '\t' || c == '' || c == '{' || c == '}' || c == ';' || c == '"' || c == "'"
        if &expandtab == "noexpandtab"
            return "\<Tab>"
        else
            return TabAlign()
        endif
    else
        return "\<C-P>"
    endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <S-Tab> <C-R>=TabAlign()<CR>

if has("autocmd")
    filetype plugin indent on
    syntax on

endif " has ("autocmd")
map µ :set hlsearch<CR>:call Auto_Highlight_Cword()<CR>

function! Auto_Highlight_Cword()
    exe "let @/='\\<".expand("<cword>")."\\>'"
endfunction

" }}}

"set cinoptions=
"set cinoptions+=,t0            " type on the line before the functions is not idented
"set cinoptions+=,:2,=2         " indent case ...: of 2 from the switch {
"set cinoptions+=,(0,W4         " indent in functions ( ... ) when it breaks
"set cinoptions+=,g2,h2         " indent C++ scope of 2, and the members from 2 from it

set cinoptions=
set cinoptions+=t0             " type on the line before the functions is not idented
set cinoptions+=:2,=2          " indent case ...: of 2 from the switch {
set cinoptions+=(0,Ws          " indent in functions ( ... ) when it breaks
set cinoptions+=g2,h2          " indent C++ scope of 2, and the members from 2 from it
set cinoptions+=m1             " aligh the closing ) properly
set cinoptions+=L0.5s
set cinoptions+=j1             " java/javascript -> fixes blocks
set cinoptions+=l0.5s          " align code after label ignoring braces.

let c_gnu=1
let c_space_errors=1
let c_no_curly_error=1

let git_diff_spawn_mode=2

set background=light
hi clear
if exists("syntax_on")
   syntax reset
endif

" a.vim
let g:alternateRelativeFiles   = 1
let g:alternateExtensions_blk  = "h"
let g:alternateExtensions_blkk = "h"
let g:alternateExtensions_h    = "c,cpp,cxx,cc,CC,blk,blkk"

fun! <SID>Y(a)
    if strlen(a:a) != 6 || a:a == "yellow"
        return a:a
    endif
    if has("gui_running")
        return "#".a:a
    endif
    let l:r = ("0x" . strpart(a:a, 0, 2)) + 0
    let l:g = ("0x" . strpart(a:a, 2, 2)) + 0
    let l:b = ("0x" . strpart(a:a, 4, 2)) + 0
    if &t_Co == 88
        let l:gray  = 10
        let l:cube  = 4
        let l:shift = 79
    else
        let l:gray  = 26
        let l:cube  = 6
        let l:shift = 232
    endif

    if l:r * l:gray / 256 == l:g * l:gray / 256 && l:r * l:gray / 256 == l:b * l:gray / 256
        let l:s = l:r * l:gray / 256
        if l:s == 0
            return "black"
        elseif l:s == l:gray - 1
            return "white"
        else
            return l:shift + l:s
        endif
    endif
    let l:x = ((l:r * l:cube) / 256)
    let l:y = ((l:g * l:cube) / 256)
    let l:z = ((l:b * l:cube) / 256)
    return 16 + ((l:x * l:cube + l:y) * l:cube) + l:z
endfun

fun! <SID>myhi(cls, m, fg, bg)
    if has("gui_running")
        exec "hi ".a:cls." gui=".a:m." guifg=".<SID>Y(a:fg)." guibg=".<SID>Y(a:bg)
    else
        exec "hi ".a:cls." cterm=".a:m." ctermfg=".<SID>Y(a:fg)." ctermbg=".<SID>Y(a:bg)
    endif
endfun


highlight TrailSpaces ctermbg=darkblue
match TrailSpaces / \+$/

exec <SID>myhi("TrailSpaces",        "NONE",       "white", "darkblue")
exec <SID>myhi("OverLength",         "NONE",      "yellow", "black")
exec <SID>myhi("Visual",             "NONE",       "white", "darkgrey")
exec <SID>myhi("IncSearch",     "underline",      "yellow", "darkblue")
exec <SID>myhi("Search",             "NONE",       "black", "darkblue")
exec <SID>myhi("SearchCurrent", "underline",      "yellow", "darkgrey")

exec <SID>myhi("NonText",            "NONE",    "darkgray", "NONE")

exec <SID>myhi("SpellBad",           "bold",       "white", "red")
exec <SID>myhi("SpellCap",           "NONE",    "lightred", "NONE")
exec <SID>myhi("SpellLocal",    "underline",   "darkgreen", "NONE")
exec <SID>myhi("SpellRare",     "underline",      "yellow", "NONE")
exec <SID>myhi("Todo",          "underline",      "yellow", "darkgrey")
exec <SID>myhi("Error",              "bold",       "white", "red")
exec <SID>myhi("SpecialKey",         "NONE",      "yellow", "darkblue")

exec <SID>myhi("Label",              "NONE",  "darkyellow", "NONE")
exec <SID>myhi("cUserLabel",         "NONE",      "yellow", "NONE")
exec <SID>myhi("Conditional",        "NONE",  "darkyellow", "NONE")
exec <SID>myhi("Repeat",             "NONE",  "darkyellow", "NONE")
exec <SID>myhi("Statement",          "NONE",  "darkyellow", "NONE")

exec <SID>myhi("StorageClass",       "NONE",       "green", "NONE")
exec <SID>myhi("Type",               "NONE",       "green", "NONE")
exec <SID>myhi("Structure",          "NONE",       "green", "NONE")
exec <SID>myhi("Directory",          "NONE",       "green", "NONE")

exec <SID>myhi("Include",            "NONE", "darkmagenta", "NONE")
exec <SID>myhi("PreProc",            "NONE", "darkmagenta", "NONE")
exec <SID>myhi("Macro",              "NONE",    "darkblue", "NONE")
exec <SID>myhi("SpecialChar",        "NONE", "darkmagenta", "NONE")

exec <SID>myhi("Character",          "NONE",         "red", "NONE")
exec <SID>myhi("String",             "NONE",     "magenta", "NONE")
exec <SID>myhi("Constant",           "NONE",         "red", "NONE")

exec <SID>myhi("Function",           "NONE",        "blue", "NONE")
exec <SID>myhi("Identifier",         "NONE",        "blue", "NONE")
exec <SID>myhi("Keyword",            "NONE",       "brown", "NONE")
exec <SID>myhi("Operator",           "bold",      "yellow", "NONE")

" C")
exec <SID>myhi("cFunction",          "bold",        "cyan", "NONE")
exec <SID>myhi("cString",            "NONE",     "magenta", "NONE")
exec <SID>myhi("cStructure",         "NONE",   "darkgreen", "NONE")

" Go")
exec <SID>myhi("goFunction",         "bold",        "cyan", "NONE")
exec <SID>myhi("goFunctionCall",     "bold",        "cyan", "NONE")
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1




if has("gui_running") || &t_Co >= 88
    if has("gui_running")
        exec <SID>myhi("Normal",       "NONE",       "dfdfdf",    "00000f")
        exec <SID>myhi("MoreMsg",      "NONE",       "dfdfdf",    "00000f")
    else
        exec <SID>myhi("Normal",       "NONE",       "dfdfdf",    "NONE")
        exec <SID>myhi("MoreMsg",      "NONE",       "dfdfdf",    "NONE")
    endif
    exec <SID>myhi("Comment",      "NONE",       "5F5F8A",    "NONE")
    exec <SID>myhi("Folded",       "NONE",       "7C7CCB",    "NONE")



    exec <SID>myhi("StatusLine",   "NONE",     "yellow",   "333333")
    exec <SID>myhi("StatusLineNc", "NONE",     "dfdfdf",   "1c1c1c")
    exec <SID>myhi("WildMenu",     "NONE",      "white",   "0f0f2f")
    exec <SID>myhi("VertSplit",    "NONE",   "darkgray",   "0f0f2f")

    exec <SID>myhi("MatchParen",   "NONE",      "white",   "0f0f2f")
    exec <SID>myhi("Pmenu",        "NONE",     "dfdfdf",   "0f0f2f")
    exec <SID>myhi("PmenuSel",     "NONE",      "white",   "3f3f7f")
    exec <SID>myhi("PmenuSbar",    "NONE",      "white",   "0f0f2f")
    exec <SID>myhi("PmenuThumb",   "NONE",     "3f3f7f",   "3f3f7f")

    exec <SID>myhi("ColorColumn",  "bold",      "NONE",    "202020")


    " diff
    exec <SID>myhi("DiffAdd",      "NONE",       "green",     "NONE")
    exec <SID>myhi("DiffDelete",   "NONE",     "darkred",     "NONE")
    exec <SID>myhi("DiffChange",   "NONE",        "NONE",   "333333")
    exec <SID>myhi("DiffText",     "underline",   "NONE",     "NONE")

    " Python
    exec <SID>myhi("pythonStatement",   "NONE", "1E90FF",    "NONE")
    exec <SID>myhi("pythonConditional", "NONE", "1E90FF",    "NONE")
    exec <SID>myhi("pythonFunction",    "bold", "3CB371",    "NONE")
    exec <SID>myhi("pythonOperator",    "NONE", "3CB371",    "NONE")
    exec <SID>myhi("Exception",         "bold", "FFFF33",    "NONE")
    exec <SID>myhi("javaFuncDef",       "bold", "3CB371",    "NONE")
    exec <SID>myhi("javaBraces",        "bold", "FFFF33",    "NONE")
else
    exec <SID>myhi("StatusLine",        "NONE",    "white",  "blue")
    exec <SID>myhi("StatusLineNc",      "NONE",    "black", "white")
    exec <SID>myhi("WildMenu",          "NONE",    "white",  "NONE")
    exec <SID>myhi("VertSplit",         "NONE", "darkgray",  "NONE")

    exec <SID>myhi("Comment",           "NONE",  "blue",     "NONE")
    exec <SID>myhi("Folded",            "NONE",  "blue",     "NONE")

    exec <SID>myhi("MatchParen",   "underline",  "NONE",     "NONE")
    exec <SID>myhi("Pmenu",             "NONE",  "gray",    "black")
    exec <SID>myhi("PmenuSel",          "NONE", "black",     "gray")
    exec <SID>myhi("PmenuSbar",         "NONE",  "blue",     "blue")
    exec <SID>myhi("PmenuThumb",        "NONE",  "gray",     "gray")
endif
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_powerline_fonts = 1
call airline#parts#define_raw('linenr', '%3l')
let g:airline_section_z = airline#section#create(['%2p%% ',
            \ g:airline_symbols.linenr .' ', 'linenr', ':%2c '])
" Custom
hi def link htmlTag htmlStatement
hi def link htmlEndTag htmlStatement
setl foldmethod=marker
nnoremap <space> za
call pathogen#infect()
" syntastic {{{
let g:syntastic_mode_map = { 'mode': 'inactive',
                         \ 'passive_filetypes': [ 'python', 'sh', 'php', 'javascript', 'java', 'cpp', 'c' ],
                         \ 'active_filetypes': [ ] }
let g:syntastic_ignore_files = ['^/usr/include/']
let g:syntastic_auto_loc_list=1
let g:syntastic_auto_jump=0
let g:syntastic_check_on_open=1
let g:syntastic_silent_make=0

let g:syntastic_c_compiler = 'clang'
let g:syntastic_c_compiler_options = ''
let g:syntastic_c_include_dirs = [ ]
let g:syntastic_c_no_include_search = 1
let g:syntastic_c_no_default_include_dirs = 1

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ''
let g:syntastic_cpp_include_dirs = [ ]
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_no_default_include_dirs = 1

let g:syntastic_python_checkers = ['pylint']

let g:syntastic_php_checkers = ['php', 'phpmd', 'phpcs']
" let :E :Explore (syntastic defines an Errors command which makes :E
" ambiguous)
command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>

" UltiSnips
let g:UltiSnipsExpandTrigger       = "<tab>"
let g:UltiSnipsListSnippets        = "<F2>"
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

let g:UltiSnipsEditSplit = 'vertical'

" a.vim
let g:alternateRelativeFiles   = 1
let g:alternateExtensions_blk  = "h"
let g:alternateExtensions_blkk = "h"
let g:alternateExtensions_h    = "c,cpp,cxx,cc,CC,blk,blkk"

" ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files && git submodule -q foreach ''for file in $(git ls-files); do echo $name/$file; done''']


"}}}
" Fold starts with ╚, nb lines is right aligned 78 cols
function! MyFoldText()
    let nblines = v:foldend - v:foldstart + 1
    if nblines < 100
        if nblines < 10
            let nblines = ' '.nblines
        endif
        let nblines = ' '.nblines
    elseif nblines >= 1000
        let nblines = '###'
    endif
    let w = 78 - &foldcolumn - (&number ? 8 : 0)
    let line = getline(v:foldstart)
    let comment = substitute(line, '^\W\+\|{{{\d\=\|\W\+$', '', 'g')
    let foldLevelStr = repeat("═", v:foldlevel - 1)
    let expansionString ='╞'.repeat("═", w - 4 - strwidth(nblines.comment.foldLevelStr)).'╡'
    let txt = '╚'.foldLevelStr . '╡' . comment . expansionString . nblines
    let empty = repeat(" ", winwidth(0) - strwidth(txt))
    let txt = txt . empty
    return txt
endfunction
set foldtext=MyFoldText()
