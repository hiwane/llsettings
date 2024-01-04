if exists('g:loaded_lightline_settings')
  finish
endif
let g:loaded_lightline_settings = 1

let g:lightline = extend(get(g:, 'lightline', {}), {
  \ 'colorscheme': 'wombat',
  \ 'mode_map': {'c': 'NORMAL'},
  \ 'active': {
    \ 'left': [ [ 'mode', 'paste', 'readonly'],
    \           [ 'gbranch', 'filename'] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'filefmt-enc', 'filetype'] ]
    \ },
  \ 'inactive': {
    \ 'left': [ [ 'filename'] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ] ] },
  \ 'component_function': {
      \   'filefmt-enc': 'llsettings#filefmtenc',
      \   'readonly': 'llsettings#readonly',
      \   'gbranch': 'llsettings#git_branch',
      \   'filename': 'llsettings#filename',
      \ },
\ }, 'keep')

augroup vimrc_lightline
  autocmd!
  autocmd FileType * call llsettings#filetype()
  autocmd OptionSet * call llsettings#optionset()
  autocmd TextChanged,TextChangedI * call llsettings#textchanged()
  autocmd BufEnter,BufFilePost,FileReadPost * call llsettings#fileread()
  autocmd BufWritePost,FileWritePost * call llsettings#writefile()
augroup END

" vim:set et ts=2 sts=2 sw=2 tw=0:
