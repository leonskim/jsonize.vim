if exists('g:loaded_jsonize') | finish | endif
let g:loaded_jsonize = 1

command! -range=% Jsonize call jsonize#FormatRange(<line1>, <line2>)
command! -range=% Jsonfmt call jsonize#FormatRange(<line1>, <line2>)

xnoremap <silent> <leader>jf :<C-u>call jsonize#FormatVisual()<CR>
nnoremap <silent> <leader>jf :Jsonize<CR>
