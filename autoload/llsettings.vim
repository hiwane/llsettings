
let b:ll_dict = {}

function! s:fileencoding() " {{{
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction " }}}

let s:fmtdic = {'unix' : 'UX', 'dos': 'WIN', 'mac' : 'MAC'}
function! llsettings#_filefmtenc() " {{{
  let fmt = &fileformat
  if has_key(s:fmtdic, fmt)
    let fmt = s:fmtdic[fmt]
  endif

  return fmt . ',' . s:fileencoding()
endfunction " }}}

function! llsettings#modified() " {{{
  return &modified ? ' +' : &modifiable ? '' : ' -'
endfunction " }}}

function! llsettings#readonly() " {{{
  return &readonly ? 'x' : ''
endfunction " }}}

function! llsettings#_filename() " {{{
  return (
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]'
        \  ) . llsettings#modified()
endfunction " }}}

function! llsettings#fugitive() " {{{
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#Head')
      return fugitive#Head()
    elseif &ft !~? 'vimfiler\|gundo' && exists('*fugitive#statusline')
      return fugitive#statusline()
    endif
  catch
    return v:errmsg
  endtry
  return ''
endfunction " }}}

function! llsettings#git_branch() abort " {{{
  try
    return b:ll_dict['gbranch']
  catch
	return 'err'
  endtry
endfunction " }}}

function! llsettings#filename() abort " {{{
  try
    return b:ll_dict['filename']
  catch
  	return llsettings#_filename()
  endtry
endfunction " }}}

function! llsettings#filefmtenc() abort " {{{
  try
    return get(b:ll_dict, 'fenc', 'unknown')
  catch
    return 'err'
  endtry
endfunction " }}}

function! llsettings#filetype() abort " {{{
  if exists('b:ll_dict')
    let b:ll_dict.ft = &ft
  endif
endfunction " }}}

function! llsettings#writefile() abort " {{{
  call llsettings#textchanged()
endfunction " }}}

function! llsettings#optionset() abort " {{{
  if exists('b:ll_dict')
    let b:ll_dict.fenc = llsettings#_filefmtenc()
    let b:ll_dict.ro = llsettings#readonly()
    call llsettings#writefile()
  endif
endfunction " }}}

function! llsettings#textchanged() abort " {{{
  if !exists('b:ll_dict')
    let b:ll_dict = {}
  endif

  let b:ll_dict.modified = llsettings#modified()
  let b:ll_dict.filename = llsettings#_filename()
endfunction " }}}

function! llsettings#fileread() abort " {{{
  let b:ll_dict = {}
  call llsettings#filetype()
  call llsettings#optionset()
  call llsettings#textchanged()
  let b:ll_dict.filename = llsettings#_filename()
  let b:ll_dict.gbranch = llsettings#fugitive()
endfunction " }}}

" vim:set et ts=2 sts=2 sw=2 tw=0:
