ctrlp-docset
============

a ctrlp.vim extension - pick out from docset 

## INTRO

Docset finder with an intuitive interface.   
This is extension plugin for [CtrlP](http://kien.github.com/ctrlp.vim)

## INSTALL

* .vimrc

```sh 
# If you use Vundle

Bundle 'git://github.com/kien/ctrlp.vim.git'
Bundle 'git://github.com/tokorom/ctrlp-docset.git'
```

## USAGE

```sh
:CtrlPDocset
```

## OPTIONS

Set the docsetutil command:

```sh
let g:ctrlp_docset_docsetutil_command = '/Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil'
```

Set the docset filepath each filetype:

```sh
let g:ctrlp_docset_filepaths = {'objc': '~/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleiOS6.0.iOSLibrary.docset'}
```

Set the command for opening the selected file:

```sh
# Default
let g:ctrlp_docset_accept_command = ':!open "file://%s"'

# If you would like to use w3m.vim
let g:ctrlp_docset_accept_command = ':W3mSplit local %s'
```

