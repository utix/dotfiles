set nocompatible                " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set esckeys                     " allow usage of curs keys within insert mode

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

set tags=tags;/,.tags;/,TAGS;/
exe "set path=." . system("echo | cpp -v 2>&1 | grep '^ .*/include' | tr -d \"\n\" | tr \" \" \",\"")
set path+=.;/

set laststatus=2                " show status line?  Yes, always!
if v:version >= 703
"    set cursorline
    set undofile                             " Pour activer la feature
    set undodir=~/.cache/vim/bkp           " Pour ranger tous les fichier d'undo
                                             " au même endroit
au BufWritePre /tmp/* setl noundofile    " Pour ignorer les fichiers
                                         " qui sont dans /tmp
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
hi SpecialKey cterm=bold ctermfg=DarkRed ctermbg=none

au BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif

au BufWinEnter *   syn match ErrorMsg "\%u00A0"
let loaded_matchparen = 1

filetype plugin indent on

au FileType php  set et sts=4 sw=4
au FileType python  set et sts=4 sw=4
au FileType html set et sts=4 sw=4 syntax=php
au FileType java set et sts=4 sw=4
au FileType c set et sts=4 sw=4
au FileType cpp set et sts=4 sw=4
au FileType javascript set et sts=2 sw=2
au FileType html,xhtml,xml setlocal sw=2 syntax=smarty
au FileType css  set et sts=4 sw=4
au FileType sql  set et sts=4 sw=4
au FileType actionscript  set et sts=4 sw=4

au BufRead,BufNewFile *.blk,*.fc setf c
au BufRead,BufNewFile *.blkk setf cpp

let c_gnu=1
let c_space_errors=1
let c_no_curly_errors=1

" IOP
au BufRead,BufNewFile *.iop setf d
set et sts=4 sw=4
hi MatchParen   cterm=underline  ctermfg=none       ctermbg=none
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
map <F3> \be
map! <F3> <Esc> \be
map <F4> :gr! -w <cword><cr>
" spell check
map <F5> :setlocal spell! spelllang=en_us<CR>
map <S-F5> z=
map <F6> ma
map <F7> `a
map <F8> :JavaImport<CR>
map <S-F8> :JavaImportOrganize<CR>
map [32~ :JavaImportOrganize<CR>
map <F9> :vsplit<cr>
map <F10> :vsplit<cr>:bn<cr>
"set makeprg=LC_ALL=C\ unbuffer\ make
map <F11> :make package<cr>
autocmd FileType java no <F11> :make clean install<cr>
autocmd FileType java no <F2> :JavaSearch<cr>
au FileType java set makeprg=PYTHONUNBUFFERED=1\ rainbow\ --config=mvn3\ --\ mvn\ $*
au FileType pom  set makeprg=PYTHONUNBUFFERED=1\ rainbow\ --config=mvn3\ --\ mvn\ $*
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
    if c == ' ' || c == '\t' || c == '' || c == '{' || c == '}' || c == ';' || c == '"' || c == "'"
        return TabAlign()
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

if version >= 703
    set cc=+1
    hi ColorColumn cterm=none ctermfg=none ctermbg=darkgray
else
    au FileType c,cpp match OverLength /\%79v.\+/
    hi OverLength cterm=none ctermfg=none ctermbg=darkblue
endif

" a.vim
let g:alternateRelativeFiles   = 1
let g:alternateExtensions_blk  = "h"
let g:alternateExtensions_blkk = "h"
let g:alternateExtensions_h    = "c,cpp,cxx,cc,CC,blk,blkk"
if has("gui_running")
    set guioptions=eit
    set guifont=terminus
    set guicursor=a:blinkon0
    set background=light

    fun! GuiTabLabel()
        let label = ''
        let bufnrlist = tabpagebuflist(v:lnum)

        " Append the number of windows in the tab page if more than one
        let wincount = tabpagewinnr(v:lnum, '$')
        let label .= wincount

        " Add '[*]' if one of the buffers in the tab page is modified
        for bufnr in bufnrlist
            if getbufvar(bufnr, "&modified")
                let label .= '[*]'
                break
            endif
        endfor


        if exists("t:tabname")
            return t:tabname . ': ' . label
        else
            return label . '[' . bufname(bufnrlist[tabpagewinnr(v:lnum) - 1]) .']'
        endif
    endf
    set guitablabel=%{GuiTabLabel()}
endif

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
if has("gui_running") || &t_Co >= 88
    if has("gui_running")
        exec <SID>myhi("Normal",       "none",       "dfdfdf",    "00000f")
        exec <SID>myhi("MoreMsg",      "none",       "dfdfdf",    "00000f")
    else
        exec <SID>myhi("Normal",       "none",       "dfdfdf",    "NONE")
        exec <SID>myhi("MoreMsg",      "none",       "dfdfdf",    "NONE")
    endif
    exec <SID>myhi("Comment",      "none",       "5F5F8A",    "NONE")
    exec <SID>myhi("Folded",       "none",       "7C7CCB",    "NONE")

    exec <SID>myhi("SpecialKey",   "none",       "696922",    "222269")
    exec <SID>myhi("Todo",         "underline",  "yellow",    "333333")
    exec <SID>myhi("Error",        "bold",       "white",     "red")

    exec <SID>myhi("Function",     "none",       "4fcfcf",    "NONE")
    exec <SID>myhi("Identifier",   "none",       "4fcfcf",    "NONE")

    exec <SID>myhi("Cursor",       "reverse",    "dfdfdf",    "black")
"   exec <SID>myhi("CursorLine",   "none",       "NONE",      "111111")
    exec <SID>myhi("Visual",       "none",       "NONE",      "333333")
    exec <SID>myhi("IncSearch",    "underline",  "yellow",    "darkblue")
    exec <SID>myhi("Search",       "none",       "grey",      "darkblue")

    exec <SID>myhi("StatusLine",   "none",       "yellow",    "333333")
    exec <SID>myhi("StatusLineNc", "none",       "dfdfdf",    "1c1c1c")
    exec <SID>myhi("WildMenu",     "none",       "white",     "0f0f2f")
    exec <SID>myhi("VertSplit",    "none",       "darkgray",  "0f0f2f")
    exec <SID>myhi("NonText",      "none",       "darkgray",  "NONE")

    exec <SID>myhi("MatchParen",   "none",       "white",     "0f0f2f")
    exec <SID>myhi("Pmenu",        "none",       "dfdfdf",    "0f0f2f")
    exec <SID>myhi("PmenuSel",     "none",       "white",     "3f3f7f")
    exec <SID>myhi("PmenuSbar",    "none",       "white",     "0f0f2f")
    exec <SID>myhi("PmenuThumb",   "none",       "3f3f7f",    "3f3f7f")

    exec <SID>myhi("SpellBad",     "underline",  "FF8362",    "NONE")
    exec <SID>myhi("SpellCap",     "none",       "lightred",  "NONE")
    exec <SID>myhi("SpellLocal",   "underline",  "darkgreen", "NONE")
    exec <SID>myhi("SpellRare",    "underline",  "yellow",    "NONE")

    exec <SID>myhi("Label",        "none",       "bf7f00",    "NONE")
    exec <SID>myhi("Conditional",  "none",       "bf7f00",    "NONE")
    exec <SID>myhi("Repeat",       "none",       "bf7f00",    "NONE")
    exec <SID>myhi("Statement",    "none",       "bf7f00",    "NONE")

    exec <SID>myhi("StorageClass", "none",       "098209",    "NONE")
    exec <SID>myhi("Type",         "none",       "0eca0e",    "NONE")
    exec <SID>myhi("Structure",    "none",       "darkgreen", "NONE")
    exec <SID>myhi("Directory",    "none",       "098209",    "NONE")

    exec <SID>myhi("Include",      "none",       "bf0fbf",    "NONE")
    exec <SID>myhi("PreProc",      "none",       "bf0fbf",    "NONE")
    exec <SID>myhi("Macro",        "none",       "bf0fbf",    "NONE")
    exec <SID>myhi("SpecialChar",  "none",       "bf0fbf",    "NONE")

    exec <SID>myhi("Character",    "none",       "bf0f0f",    "NONE")
    exec <SID>myhi("String",       "none",       "magenta",   "NONE")
    exec <SID>myhi("Constant",     "none",       "bf0f0f",    "NONE")

    " diff
    exec <SID>myhi("DiffAdd",      "none",       "green",     "NONE")
    exec <SID>myhi("DiffDelete",   "none",       "darkred",   "NONE")
    exec <SID>myhi("DiffChange",   "none",       "NONE",      "333333")
    exec <SID>myhi("DiffText",     "underline",  "NONE",      "NONE")

    " C
    exec <SID>myhi("cFunction",    "bold",       "75FFFD",    "NONE")
    exec <SID>myhi("cString",      "none",       "magenta" ,  "NONE")
    exec <SID>myhi("cStructure",   "none",       "darkgreen", "NONE")
    exec <SID>myhi("ColorColumn",  "bold",       "NONE",      "202020")
    exec <SID>myhi("Label",        "none",       "FFFF00",    "NONE")
    exec <SID>myhi("OverLength",   "none",       "NONE",      "592929")
    " Python
    exec <SID>myhi("pythonStatement",   "none",  "1E90FF",    "NONE")
    exec <SID>myhi("pythonConditional", "none",  "1E90FF",    "NONE")
    exec <SID>myhi("pythonFunction",    "bold",  "3CB371",    "NONE")
    exec <SID>myhi("pythonOperator",    "none",  "3CB371",    "NONE")
    exec <SID>myhi("Exception",         "bold",  "FFFF33",    "NONE")
    exec <SID>myhi("javaFuncDef",       "bold",  "3CB371",    "NONE")
    exec <SID>myhi("javaBraces",       "bold",  "FFFF33",    "NONE")
else
    hi Comment      cterm=none       ctermfg=blue       ctermbg=none
    hi Folded       cterm=none       ctermfg=brown      ctermbg=none

    hi Visual       cterm=reverse    ctermfg=none       ctermbg=none
    hi IncSearch    cterm=none       ctermfg=lightred   ctermbg=none
    hi Search       cterm=underline  ctermfg=lightred   ctermbg=none

    hi StatusLine   cterm=none       ctermfg=white      ctermbg=blue
    hi StatusLineNc cterm=none       ctermfg=black      ctermbg=white
    hi WildMenu     cterm=none       ctermfg=white      ctermbg=none
    hi VertSplit    cterm=none       ctermfg=darkgray   ctermbg=none
    hi NonText      cterm=none       ctermfg=darkgray   ctermbg=none

    hi MatchParen   cterm=underline  ctermfg=none       ctermbg=none
    hi Pmenu        cterm=none       ctermfg=gray       ctermbg=black
    hi PmenuSel     cterm=none       ctermfg=black      ctermbg=gray
    hi PmenuSbar    cterm=none       ctermfg=blue       ctermbg=blue
    hi PmenuThumb   cterm=none       ctermfg=gray       ctermbg=gray

    hi SpellBad     cterm=underline  ctermfg=lightred   ctermbg=none
    hi SpellCap     cterm=none       ctermfg=lightred   ctermbg=none
    hi SpellLocal   cterm=underline  ctermfg=darkgreen  ctermbg=none
    hi SpellRare    cterm=none       ctermfg=none       ctermbg=none
endif
" Custom
hi def link htmlTag htmlStatement
hi def link htmlEndTag htmlStatement
setl foldmethod=marker
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
" Fold starts with ╚⇒, nb lines is right aligned 78 cols
function! MyFoldText()
    let nblines = v:foldend - v:foldstart + 1
    let w = 78 - &foldcolumn - (&number ? 8 : 0)
    let line = getline(v:foldstart)
    let comment = substitute(line, '^\W\+\|{{{\d\=\|\W\+$', '', 'g')
    let foldLevelStr = repeat("═", v:foldlevel - 1)
    let expansionString = repeat("┈", w - 3 - strwidth(nblines.comment.foldLevelStr))
    let txt = '╚'.foldLevelStr . '⇒ ' . comment . expansionString . nblines
    let empty = repeat(" ", winwidth(0) - strwidth(txt))
    let txt = txt . empty
    return txt
endfunction
set foldtext=MyFoldText()
