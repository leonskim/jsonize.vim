function! s:SanitizeAndStructure(text) abort
  let s = a:text
  let s = substitute(s, '\v''([^'']{-})''', '"\1"', 'g')
  let s = substitute(s, '\v([{,]\s*)\zs([A-Za-z_][A-Za-z0-9_]*)\ze\s*:', '"\2"', 'g')
  let s = substitute(s, ',\s*\n\s*\]', '\n]', 'g')
  let s = substitute(s, ',\s*\n\s*}', '\n}', 'g')
  let s = substitute(s, ',\s*\]', ']', 'g')
  let s = substitute(s, ',\s*}', '}', 'g')
  let s = substitute(s, '\v\s+', ' ', 'g')
  let s = substitute(s, '\v\[\s+', '[', 'g')
  let s = substitute(s, '\v\s+\]', ']', 'g')
  let s = substitute(s, '\v\[([A-Za-z]+)\]', '<!KEEP!\1!KEEP!>', 'g')
  let s = substitute(s, '\v\{\s*', "{\n", 'g')
  let s = substitute(s, '\v\[\s*', "[\n", 'g')
  let s = substitute(s, '\v,\s*', ",\n", 'g')
  let s = substitute(s, '\v\s*\}', "\n}", 'g')
  let s = substitute(s, '\v\s*\]', "\n]", 'g')
  let s = substitute(s, '<!KEEP!\([A-Za-z]\+\)!KEEP!>', '[\1]', 'g')

  let lines = split(s, "\n")
  let result = []
  let indent = 0
  for line in lines
    let line = substitute(line, '^\s*', '', '')

    if line =~# '^\s*$'
      continue
    endif

    if line =~# '^\s*[}\]]'
      let indent = max([0, indent - 2])
    endif

    call add(result, repeat(' ', indent) . line)

    if line =~# '[{[]$'
      let indent += 2
    endif
  endfor

  let s = join(result, "\n")
  return ['ok', '', s]
endfunction

function! jsonize#FormatVisual() abort
  if &buftype !=# '' || !&modifiable
    echo "Not a normal file buffer." | return
  endif
  silent! normal! gv
  if getpos("'<")[1] == 0 || getpos("'>")[1] == 0
    echo "No visual selection." | return
  endif
  silent! normal! "zy
  let seltext = getreg('z')
  let [st, _msg, out] = s:SanitizeAndStructure(seltext)
  if st !=# 'ok'
    echohl WarningMsg | echom "Jsonize: formatting failed; selection unchanged." | echohl None
    return
  endif
  call setreg('z', out)
  silent! normal! gv"zp
  echo "Jsonize: JSON formatted (selection)"
endfunction

function! jsonize#FormatRange(l1, l2) abort
  let orig = join(getline(a:l1, a:l2), "\n")
  let [st, _m, out] = s:SanitizeAndStructure(orig)
  if st !=# 'ok'
    echohl WarningMsg | echom "Jsonize: formatting failed; text unchanged." | echohl None
    return
  endif
  let new = split(out, "\n")
  silent execute a:l1.','.a:l2.'delete _'
  call append(a:l1 - 1, new)
  echo "Jsonize: JSON formatted (range)"
endfunction
