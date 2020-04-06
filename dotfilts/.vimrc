" 设置编码
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

" 开启语法高亮功能
syntax enable

" 允许用指定语法高亮配色方案替换默认方案
syntax on

" 显示行号
set nu
set number

set cursorline
set cul

set mouse=a
set selection=exclusive
set selectmode=mouse,key

set showmatch

" 设置Tab长度为4空格
set tabstop=2
" 设置自动缩进长度为4空格
set shiftwidth=2
" 继承前一行的缩进方式，适用于多行注释
set autoindent

set paste

set listchars=tab:>-,trail:-

" 总是显示状态栏
set laststatus=2
" 显示光标当前位置
set ruler

filetype plugin indent on

" 让vimrc配置变更立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC