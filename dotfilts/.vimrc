" 光标键失效
"""""""""""""""""""""
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" 标签页显示序号
"""""""""""""""""""""
set tabline=%!TabLine()  " custom tab pages line
function TabLine()
    let s = '' " complete tabline goes here
    " loop through each tab page
    for t in range(tabpagenr('$'))
        " set highlight
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " set the tab page number (for mouse clicks)
        let s .= '%' . (t + 1) . 'T'
        let s .= ' '
        " set page number string
        let s .= t + 1 . ' '
        " get buffer names and statuses
        let n = ''      "temp string for buffer names while we loop and check buftype
        let m = 0       " &modified counter
        let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
        " loop through each buffer in a tab
        for b in tabpagebuflist(t + 1)
            " buffer types: quickfix gets a [Q], help gets [H]{base fname}
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
            if getbufvar( b, "&buftype" ) == 'help'
                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
            elseif getbufvar( b, "&buftype" ) == 'quickfix'
                let n .= '[Q]'
            else
                let n .= pathshorten(bufname(b))
            endif
            " check and ++ tab's &modified count
            if getbufvar( b, "&modified" )
                let m += 1
            endif
            " no final ' ' added...formatting looks better done later
            if bc > 1
                let n .= ' '
            endif
            let bc -= 1
        endfor
        " add modified label [n+] where n pages in tab are modified
        if m > 0
            let s .= '[' . m . '+]'
        endif
        " select the highlighting for the buffer names
        " my default highlighting only underlines the active tab
        " buffer names.
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " add buffer names
        if n == ''
            let s.= '[New]'
        else
            let s .= n
        endif
        " switch to no underlining and add final space to buffer list
        let s .= ' '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLineFill#999Xclose'
    endif
    return s
endfunction

" Python-mode
""""""""""""""""""""
let g:pymode_python = 'python3'
" 检查错误 pyflakes
map <leader>p :PymodeLintAuto<cr>
" 自动修复 PEP8
map <leader>P :PymodeLint<cr>

" 非vi
""""""""""""""""""""
set nocompatible

" 中文帮助
""""""""""""""""""""
set helplang=cn

" 查找时自动跳转
""""""""""""""""""""
set incsearch

" 查找不区分大小写
"""""""""""""""""""
set ignorecase

" 快速运行
""""""""""""""""""""
map <F5> :call RunPy()<CR>
func! RunPy()
    if &filetype == "python"
        exec "!time python3 %"
    endif
endfunc

"创建新文件自注释
""""""""""""""""""""
autocmd BufNewFile *.py exec ":call SetComment()"
func SetComment()
    if expand("%:e") == 'py'
        call setline(1, "#!/usr/bin/env python")
    endif
endfunc

" 代码缩进
""""""""""""""""""""
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix

" 系统剪贴板
""""""""""""""""""""
set clipboard=unnamed

" 修改编码
""""""""""""""""""""
set encoding=utf-8

"关闭代码折叠
""""""""""""""""""""
set nofoldenable

" 修改配色
""""""""""""""""""""
colorscheme elflord

" 显示行号
""""""""""""""""""""
set number

" 突出显示当前栏
""""""""""""""""""""
hi CursorLine cterm=NONE ctermbg=Gray ctermfg=green
map <leader>c :set cursorline!<cr>
set cursorline

" 隐藏滚动条
""""""""""""""""""""
set guioptions-=r
set guioptions-=L
set guioptions-=b

" 自动补全
""""""""""""""""""""
"filetype plugin on
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"let g:pydiction_location='~/.vim/tools/pydiction/complete-dict'

" 语法高亮
""""""""""""""""""""
syntax on
let python_highlight_all = 1
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" 搜索时高亮
""""""""""""""""""""
set hlsearch

" Vundle 插件管理
""""""""""""""""""""
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'Lokaltog/vim-powerline'
Plugin 'scrooloose/nerdtree'
Plugin 'Yggdroot/indentLine'
Plugin 'Valloric/YouCompleteMe'
Bundle "klen/python-mode"
Bundle 'nvie/vim-flake8'
Bundle 'bronson/vim-trailing-whitespace'
Bundle 'hdima/python-syntax'
Bundle 'kien/ctrlp.vim'
call vundle#end()
filetype plugin indent on

" 文件搜索
"""""""""""""""""""
" 打开ctrlp搜索
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" 相当于mru功能，show recently opened files
map <leader>fp :CtrlPMRU<CR>
"set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux"
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz)$',
    \ }
"\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1

" 状态栏
"""""""""""""""""""
let g:Powerline_symbols = 'unicode'

" 标志无效空格
"""""""""""""""""""
map <leader><space> :FixWhitespace<cr>
" \+space去掉末尾空格

" 缩进指示线 indentLine
"""""""""""""""""""
map <leader>i :IndentLinesToggle<cr>
" \+i 关闭缩进指示线，再按开启
let g:indentLine_char = '┆'
let g:indentLine_enabled = 1

" 目录树 nerdtree F2开启和关闭树"
"""""""""""""""""""
map <F2> :NERDTreeToggle<CR>
let NERDTreeChDirMode=1
" 显示书签"
let NERDTreeShowBookmarks=1
" 设置忽略文件类型"
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
" 窗口大小"
let NERDTreeWinSize=25

" YCM
"""""""""""""""""":
" 默认配置文件路径"
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" 打开vim时不再询问是否加载ycm_extra_conf.py配置"
let g:ycm_confirm_extra_conf=0
set completeopt=longest,menu
" python解释器路径 \+r 运行程序
let g:ycm_path_to_python_interpreter='/usr/bin/python'
" 是否开启语义补全"
let g:ycm_seed_identifiers_with_syntax=1
" 是否在注释中也开启补全"
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
" 开始补全的字符数"
let g:ycm_min_num_of_chars_for_completion=1
" 补全后自动关机预览窗口"
let g:ycm_autoclose_preview_window_after_completion=1
" 禁止缓存匹配项,每次都重新生成匹配项"
let g:ycm_cache_omnifunc=0
" 字符串中也开启补全"
let g:ycm_complete_in_strings = 1
" 离开插入模式后自动关闭预览窗口"
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" 上下左右键行为"
inoremap <expr> <Down>     pumvisible() ? '\<C-n>' : '\<Down>'
inoremap <expr> <Up>       pumvisible() ? '\<C-p>' : '\<Up>'
inoremap <expr> <PageDown> pumvisible() ? '\<PageDown>\<C-p>\<C-n>' : '\<PageDown>'
inoremap <expr> <PageUp>   pumvisible() ? '\<PageUp>\<C-p>\<C-n>' : '\<PageUp>'

" 括号匹配高亮
"""""""""""""""""
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 40
let g:rbpt_loadcmd_toggle = 0

" 括号自动补全
""""""""""""""""""
au FileType python let b:delimitMate_nesting_quotes = ['"']