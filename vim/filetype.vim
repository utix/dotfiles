if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au BufRead,BufNewFile *.ml,*.mli         setf omlet
  au BufRead,BufNewFile *.JS               setf javascript
  au BufRead,BufNewFile *.jas              setf asm
  au BufRead,BufNewFile *.swfml            setf xml
  au BufRead,BufNewFile *.iop              setf d
  au BufRead,BufNewFile *.blk              setf c

  au BufRead,BufNewFile *.tpl              setf xhtml
  au BufRead,BufNewFile *.as               setf actionscript

  au BufRead,BufNewFile COMMIT_EDITMSG     setf git
  au BufNewFile,BufRead *.git/config,*/.git/config,.gitconfig setf dosini

  " HTML (.shtml and .stm for server side)
  au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm  call s:FThtml()

  " Distinguish between HTML, XHTML and Django
  fun! s:FThtml()
    let n = 1
    while n < 10 && n < line("$")
      if getline(n) =~ '<?'
        setf php
        return
      endif
      if getline(n) =~ '\<DTD\s\+XHTML\s'
        setf xhtml
        return
      endif
      if getline(n) =~ '{%\s*\(extends\|block\)\>'
        setf htmldjango
        return
      endif
      let n = n + 1
    endwhile
    setf html
  endfun

augroup END
