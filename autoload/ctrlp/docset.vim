" =============================================================================
" File: autoload/ctrlp/docset.vim
" Description: This is extension plugin for CtrlP
" Author: tokorom <github.com/tokorom>
" =============================================================================

if exists('g:loaded_ctrlp_docset') && g:loaded_ctrlp_docset
  finish
endif
let g:loaded_ctrlp_docset = 1

" ctrlp settings {{{1

let s:docset_var = {
\ 'enter': 'ctrlp#docset#enter()',
\ 'init': 'ctrlp#docset#init()',
\ 'accept': 'ctrlp#docset#accept',
\ 'lname': 'docset',
\ 'sname': 'docset',
\ 'type': 'path',
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:docset_var)
else
  let g:ctrlp_ext_vars = [s:docset_var]
endif

" Options {{{1

if !exists('g:ctrlp_docset_docsetutil_command')
  let g:ctrlp_docset_docsetutil_command = 'docsetutil'
endif

if !exists('g:ctrlp_docset_filepaths')
  let g:ctrlp_docset_filepaths = {'objc': '~/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleiOS6.1.iOSLibrary.docset'}
endif

if !exists('g:ctrlp_docset_accept_command')
  let g:ctrlp_docset_accept_command = ':!open "file://%s"'
endif

if !exists('g:ctrlp_docset_search_option')
  let g:ctrlp_docset_search_option = '-query "*" -skip-text'
endif

" ctrlp functions {{{1

function! ctrlp#docset#enter()
  let s:filetype = &filetype
endfunc

function! ctrlp#docset#init()
  if !exists('s:ctrlp_docset_index')
    let docset_filepath = s:docsetFilepath()
    if 0 < strlen(docset_filepath)
      let bin = fnamemodify(expand(g:ctrlp_docset_docsetutil_command), ':p')
      let docset = fnamemodify(expand(docset_filepath), ':p')
      let output =  bin . ' search ' . docset . ' ' . g:ctrlp_docset_search_option
      let result = split(system(output), "\n")
      let s:ctrlp_docset_index = {}
      for line in result
        let kv = split(line, "   ")
        if 1 < len(kv)
          let key = s:adjustKey(kv[0])
          let val = kv[1]
          let s:ctrlp_docset_index[key] = val
        endif
      endfor
    else
      return []
    endif
  endif
  return keys(s:ctrlp_docset_index)
endfunc

function! ctrlp#docset#accept(mode, str)
  call ctrlp#exit()
  let docset_filepath = s:docsetFilepath()
  let path = fnamemodify(expand(docset_filepath . '/Contents/Resources/Documents/' . s:ctrlp_docset_index[a:str]), ':p')
  if 0 <= match(g:ctrlp_docset_accept_command, '^:!')
    let path = escape(path, '%#')
    let path = escape(path, '\')
  endif
  let cmd = substitute(g:ctrlp_docset_accept_command, '%s', path, '')
  exec cmd
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#docset#id()
  return s:id
endfunction

" Private function {{{1

function! s:docsetFilepath()
  let filetype = s:filetype
  if has_key(g:ctrlp_docset_filepaths, filetype)
    return g:ctrlp_docset_filepaths[filetype]
  else
    echoerr "Docset is not found. please set 'g:ctrlp_docset_filepaths['" . filetype . "']." 
    return ''
  endif
endfunction

function! s:adjustKey(key)
  return substitute(a:key, '^[^/]*\/[^/]*\/', '', '')
endfunction

