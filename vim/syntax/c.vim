" setl foldmarker=/**,*/
setl foldmethod=marker
set textwidth=77
set cc=+2   " Highlight first column out of textwidth
hi ColorColumn ctermfg=DarkRed guibg=#333333 ctermbg=80 cterm=bold
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%80v.*/
syn keyword cStatement t_push t_pop t_pop_and_return t_new t_new_extra t_fmt t_scope
