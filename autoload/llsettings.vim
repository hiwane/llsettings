

function! s:dict_init() " {{{
  let b:ll_dict = {}
  let b:ll_dict.host = hostname()
endfunction " }}}

function! llsettings#hostname() " {{{
  return get(b:ll_dict, 'host', hostname())
endfunction " }}}

function! s:fileencoding() " {{{
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction " }}}

function! s:fileformat() " {{{
  return get(s:fmtdic, &fileformat, &fileformat)
endfunction " }}}

let s:fmtdic = {'unix' : 'UX', 'dos': 'WIN', 'mac' : 'MAC'}
function! llsettings#_filefmtenc() " {{{
  return s:fileformat() . ',' . s:fileencoding()
endfunction " }}}

function! llsettings#modified() " {{{
  return &modified ? ' +' : &modifiable ? '' : ' -'
endfunction " }}}

function! llsettings#readonly() " {{{
  return &readonly ? 'x' : ''
endfunction " }}}

function! llsettings#_filename() " {{{
  return (
        \ '' != expand('%:t') ? expand('%:t') : '[NoName]'
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
    return 'git_branch(' . v:errmsg . ')'
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
    return 'filefmtenc(' . v:errmsg . ')'
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
  if exists('b:ll_dict')  " autoload OptionSet で初期前に呼ばれるかも
    let b:ll_dict.fenc = llsettings#_filefmtenc()
    let b:ll_dict.ro = llsettings#readonly()
    call llsettings#writefile()
  endif
endfunction " }}}

function! llsettings#textchanged() abort " {{{
  if !exists('b:ll_dict')
    call s:dict_init()
  endif

  let b:ll_dict.modified = llsettings#modified()
  let b:ll_dict.filename = llsettings#_filename()
endfunction " }}}

function! llsettings#fileread() abort " {{{
  call s:dict_init()
  call llsettings#filetype()
  call llsettings#optionset()
  call llsettings#textchanged()
  let b:ll_dict.filename = llsettings#_filename()
  let b:ll_dict.gbranch = llsettings#fugitive()
endfunction " }}}

call llsettings#fileread()

" vim:set et ts=2 sts=2 sw=2 tw=0:
