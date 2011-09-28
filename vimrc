set nocompatible                " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing
set esckeys                     " allow usage of curs keys within insert mode

syn on
set encoding=utf-8
set ai
set background=dark
set incsearch                   " Incremental search
set hlsearch                    " hilight search
set ai
set hidden                      " allow to cycle and hide modified buffers
set viminfo='1000,/1000,:1000,<1000,@1000,n~/.viminfo
set history=1000

set tags=tags;/,.tags;/,TAGS;/
exe "set path=." . system("echo | cpp -v 2>&1 | grep '^ .*/include' | tr -d \"\n\" | tr \" \" \",\"")
set path+=.;/

set laststatus=2                " show status line?  Yes, always!
set undofile                             " Pour activer la feature
set undodir=~/.cache/vim/bkp,.           " Pour ranger tous les fichier d'undo
                                         " au même endroit
au BufWritePre /tmp/* setl noundofile    " Pour ignorer les fichiers
                                         " qui sont dans /tmp



set listchars=eol:\ ,tab:\ \ ,trail:-,extends:>,precedes:<
set list
set virtualedit+=block
set wildchar=<TAB>
set wildmenu
set modeline
set modelines=5
set wildmode=longest,full

set clipboard=unnamed          "used klipper for paste
set grepprg=fds
hi SpecialKey cterm=bold ctermfg=DarkRed ctermbg=none

au BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif

au BufWinEnter *   syn match ErrorMsg "\%u00A0"
let loaded_matchparen = 1

filetype plugin indent on

au FileType php  set et sts=4 sw=4
au FileType html set et sts=4 sw=4 syntax=php
au FileType java set et sts=4 sw=4
au FileType c set et sts=4 sw=4
au FileType cpp set et sts=4 sw=4
au FileType javascript set et sts=4 sw=4
au FileType html,xhtml,xml setlocal sw=2 syntax=smarty
au FileType css  set et sts=4 sw=4
au FileType sql  set et sts=4 sw=4
au FileType actionscript  set et sts=4 sw=4

set et sts=4 sw=4
hi MatchParen   cterm=underline  ctermfg=none       ctermbg=none
"command -nargs=+ Fds :cexpr system('fds -w <q-args>')
let g:bufExplorerFindActive=0
set pastetoggle=<F4>
noremap <F5> :source ~/.vimrc<cr>
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
map <F6> ma
map <F7> `a
map <F9> :vsplit<cr>
map <F10> :vsplit<cr>:bn<cr>
map <F12> mcHmh:%s/ \+$//ge<cr>'hzt`c
map + :cn<cr>
map - :cp<cr>
map <kPlus> :cn<cr>
map <kMinus> :cp<cr>

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
set cinoptions+=L0.5s          " align labels at 0.5 shiftwidth
set cinoptions+=:0.5s,=0.5s    " same for case labels and code following a label
set cinoptions+=g0.5s,h0.5s    " same for c++ stuff
set cinoptions+=t0             " type on the line before the functions is not idented
set cinoptions+=(0,Ws          " indent in functions ( ... ) when it breaks
set cinoptions+=m1             " aligh the closing ) properly
set cinoptions+=j1,J1          " java/javscript -> fixes blocks

let c_gnu=1
let c_space_errors=1
let c_no_curly_error=1

let git_diff_spawn_mode=2

set background=light
hi clear
if exists("syntax_on")
   syntax reset
endif

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
    exec <SID>myhi("Comment",      "none",       "afafff",    "0f0f2f")
    exec <SID>myhi("Folded",       "none",       "afafff",    "0f0f2f")

    exec <SID>myhi("SpecialKey",   "none",       "dfdfdf",    "0f0f2f")
    exec <SID>myhi("Todo",         "underline",  "yellow",    "333333")
    exec <SID>myhi("Error",        "bold",       "white",     "red")

    exec <SID>myhi("Function",     "none",       "4fcfcf",    "NONE")
    exec <SID>myhi("Identifier",   "none",       "4fcfcf",    "NONE")

    exec <SID>myhi("Cursor",       "reverse",    "dfdfdf",    "black")
    exec <SID>myhi("Visual",       "none",       "NONE",      "333333")
    exec <SID>myhi("IncSearch",    "none",       "black",     "yellow")
    exec <SID>myhi("Search",       "none",       "black",     "yellow")

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

    exec <SID>myhi("SpellBad",     "none",       "NONE",      "800000")
    exec <SID>myhi("SpellCap",     "none",       "NONE",      "004000")
    exec <SID>myhi("SpellLocal",   "none",       "NONE",      "004000")
    exec <SID>myhi("SpellRare",    "none",       "NONE",      "NONE")

    exec <SID>myhi("Label",        "none",       "bf7f00",    "NONE")
    exec <SID>myhi("Conditional",  "none",       "bf7f00",    "NONE")
    exec <SID>myhi("Repeat",       "none",       "bf7f00",    "NONE")
    exec <SID>myhi("Statement",    "none",       "bf7f00",    "NONE")

    exec <SID>myhi("StorageClass", "none",       "3fbf3f",    "NONE")
    exec <SID>myhi("Type",         "none",       "3fbf3f",    "NONE")
    exec <SID>myhi("Structure",    "none",       "3fbf3f",    "NONE")
    exec <SID>myhi("Directory",    "none",       "3fbf3f",    "NONE")

    exec <SID>myhi("Include",      "none",       "bf0fbf",    "NONE")
    exec <SID>myhi("PreProc",      "none",       "bf0fbf",    "NONE")
    exec <SID>myhi("Macro",        "none",       "bf0fbf",    "NONE")
    exec <SID>myhi("SpecialChar",  "none",       "bf0fbf",    "NONE")

    exec <SID>myhi("Character",    "none",       "bf0f0f",    "NONE")
    exec <SID>myhi("String",       "none",       "bf0f0f",    "NONE")
    exec <SID>myhi("Constant",     "none",       "bf0f0f",    "NONE")

    " diff
    exec <SID>myhi("DiffAdd",      "none",       "NONE",      "002f0f")
    exec <SID>myhi("DiffDelete",   "none",       "NONE",      "2f000f")
    exec <SID>myhi("DiffChange",   "none",       "NONE",      "00003f")
    exec <SID>myhi("DiffText",     "underline",  "NONE",      "00003f")
    exec <SID>myhi("diffRemoved",  "none",       "bf0fbf",    "NONE")

    " C
    exec <SID>myhi("cFunction",    "none",       "b0b0b0",    "NONE")
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
