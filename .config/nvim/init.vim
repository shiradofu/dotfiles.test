augroup MyGroup | autocmd! | augroup END
command! -nargs=* MyAutocmd autocmd MyGroup <args>

set encoding=utf-8            " エンコーディングをUTF-8に設定
set mouse=a                   " マウスを有効化
set showtabline=2             " タブを常に表示
set hidden                    " 保存せずにバッファを切り替え可能にする
set splitbelow                " :splitで画面を下に開く
set splitright                " :vsplitで画面を右に開く
set number                    " 左端に行数を表示
set signcolumn=number         " Gitの変更やLSPの警告を行数を上書きして表示
" set colorcolumn=80,100      " 80列・100列をハイライト
set cursorline                " カーソル行をハイライト
set ignorecase                " 検索時に大文字小文字の差を無視
set smartcase                 " 検索時に大文字が含まれていれば大文字小文字を区別
set inccommand=nosplit        " インクリメンタルサーチの結果をバッファ内でハイライト
set clipboard+=unnamedplus    " システムのクリップボードを使用
set expandtab                 " タブをスペースに展開
set tabstop=2                 " タブをスペース2つ相当として扱う
set shiftwidth=2              " デフォルトのインデントをスペース2つに設定
set smartindent               " C言語風のプログラミング言語向けの自動インデント
set shiftround                " インデントをshiftwidthの整数倍に揃える
set ttimeoutlen=5             " キーの確定待ちまでの時間
set guicursor+=c:ver10        " コマンドモードのカーソルをビーム形状に（vertical, width 10%)
set diffopt=internal,filler,algorithm:histogram,indent-heuristic " diff の設定
set fileencodings=utf-8,cp932,euc-jp,iso-20220-jp,default,latin  " ファイルエンコーディング候補
set helplang=ja,en            " ヘルプページの言語
set termguicolors             " TUIで24bitカラーを有効にする
set fillchars=vert:\ ,eob:\ , " ステータスライン・バッファの終わりを埋める文字を空白化
set shada+='10000             " 以前に編集したファイルを最大で1000件記憶
set shada-='100               " 以前に編集したファイルの最大記憶数のデフォルト(100件)を除去
set formatoptions+=ro         " 行コメント改行時にコメント文字を自動挿入

MyAutocmd FileType markdown setlocal conceallevel=0 " markdownのconcealを無効化

" 不要な機能の無効化
" https://lambdalisue.hatenablog.com/entry/2015/12/25/000046
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_ruby_provider     = 0
let g:loaded_perl_provider     = 0
let g:loaded_python3_provider  = 0
let g:vim_json_conceal         = 0
let g:vim_markdown_conceal     = 0

let g:config_dir = $XDG_CONFIG_HOME . '/nvim'
let s:asdf_dir = $ASDF_DATA_DIR . '/installs'
let g:node_host_prog = s:asdf_dir . '/nodejs/lts/.npm/lib/node_modules/neovim/bin/cli.js'

" デバッグ用ログ関数/コマンド
function! Log(var) abort
  exe 'redir >> ' g:config_dir . '/log' | silent echo a:var | redir END
endfunction
command! -nargs=1 Log call Log(<args>)

command! -bang -nargs=+ -complete=dir RgIgnore
  \ call user#rg#raw(user#rg#smart_quote_input(<q-args>), 0, <bang>0)

command! -bang -nargs=+ -complete=dir RgNoIgnore
  \ call user#rg#raw(user#rg#smart_quote_input(<q-args>), 1, <bang>0)

command! RE
  \ execute 'source ' . $MYVIMRC |
  \ call dein#recache_runtimepath() |
  \ echo "loaded"

command! PS PackerSync

let mapleader = "\<Space>"

nnoremap <silent> <BS>  :<C-u>call user#win#quit()<CR>
nnoremap <silent> g<BS> :<C-u>call user#win#tabclose()<CR>
nmap     <silent> zz :<C-u>call user#zz#do(1)<CR>
nnoremap <silent> ]q :<C-u>call user#zz#after('cmd', 'cnext')<CR>
nnoremap <silent> [q :<C-u>call user#zz#after('cmd', 'cprev')<CR>
nnoremap <silent> ]c :<C-u>call user#zz#after('map', "\<Plug>(GitGutterNextHunk)")<CR>
nnoremap <silent> [c :<C-u>call user#zz#after('map', "\<Plug>(GitGutterPrevHunk)")<CR>
" nnoremap <silent> ]e :<C-u>call user#zz#after('fn', "CocAction('diagnosticNext')")<CR>
" nnoremap <silent> [e :<C-u>call user#zz#after('fn', "CocAction('diagnosticPrevious')")<CR>
nmap     <silent> g; :<C-u>call user#zz#after('cmd', 'normal! g;')<CR>
nmap     <silent> g, :<C-u>call user#zz#after('cmd', 'normal! g,')<CR>
nmap     <silent> n  :<C-u>call user#zz#after('map', "\<Plug>(is-n)")<CR>
nmap     <silent> N  :<C-u>call user#zz#after('map', "\<Plug>(is-N)")<CR>
map      *  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
map      g* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
map      #  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
map      g# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)
nmap     t <Plug>(operator-replace)
map      Y y$
" xmap     if <Plug>(coc-funcobj-i)
" omap     if <Plug>(coc-funcobj-i)
" xmap     af <Plug>(coc-funcobj-a)
" omap     af <Plug>(coc-funcobj-a)
nnoremap <silent> o  :<C-u>call user#newline#o()<CR>
nnoremap <silent> O  :<C-u>call user#newline#O()<CR>
inoremap <expr> <CR> user#newline#cr()

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l
nnoremap <C-n> gt
nnoremap <C-p> gT
nnoremap Z <C-w>+
nnoremap Q <C-w>-
nnoremap \| 2<C-w><
nnoremap \ 2<C-w>>
nnoremap ¥ 2<C-w>>
nnoremap <C-g> <C-w>_<C-w>\|
nnoremap <C-t> <C-w>=
nnoremap <silent> go :<C-u>call user#win#move(v:count)<CR>
nnoremap <silent> g[ :<C-u>-tabm<CR>
nnoremap <silent> g] :<C-u>+tabm<CR>

nnoremap <silent> gb :<C-u>edit #<CR>
nnoremap <silent> gy :<C-u>let @+=expand('%')<CR>
nnoremap <silent> gY :<C-u>let @+=expand('%:p')<CR>
nnoremap <silent> gz :<C-u>Goyo 100<CR>
nmap     <silent> gs :<C-u>Scratch<CR>
vmap     <silent> gs <plug>(scratch-selection-reuse)
nmap     <silent> gx <Plug>(openbrowser-smart-search)
vmap     <silent> gx <Plug>(openbrowser-smart-search)
" nmap     <silent> gh <Plug>(coc-float-jump)
" nnoremap <silent> gd :<C-u>call CocAction('jumpDefinition')<CR>
" nnoremap <silent> gD :<C-u>call CocAction('jumpDefinition', 'vsplit')<CR>
" nnoremap <silent> gt :<C-u>call CocAction('jumpTypeDefinition')<CR>
" nnoremap <silent> gT :<C-u>call CocAction('jumpTypeDefinition', 'vsplit')<CR>
" nnoremap <silent> gr :<C-u>call CocActionAsync('rename')<CR>
" nnoremap <silent> ga :<C-u>CocAction<CR>

nnoremap <silent> <Leader>r :<C-u>Fern . -reveal=%<CR>
nnoremap <silent> <Leader><C-r> :<C-u>vs<CR>:<C-u>Fern . -reveal=%<CR>
nnoremap <silent> <Leader>t :<C-u>call fzf#sonictemplate#run()<CR>
nnoremap <silent> <Leader>R :<C-u>vs<CR>:<C-u>Fern .<CR>
nnoremap <silent> <Leader>o :<C-u>GFiles<CR>
nnoremap <silent> <Leader>i :<C-u>Files<CR>
nnoremap <silent> <Leader>u :<C-u>GFiles?<CR>
nnoremap <Leader>f :<C-u>RgIgnore<Space>
nnoremap <Leader>F :<C-u>RgNoIgnore<Space>
vnoremap <Leader>f :<C-u>call user#rg#visual('RgIgnore')<CR>
vnoremap <Leader>F :<C-u>call user#rg#visual('RgNoIgnore')<CR>
nnoremap <expr> <Leader>g ':<C-u>RgIgnore ' . user#rg#cword() . '<CR>'
nnoremap <expr> <Leader>G ':<C-u>RgNoIgnore ' . user#rg#cword() . '<CR>'
vnoremap <Leader>g :<C-u>call user#rg#visual('RgIgnore')<CR><CR>
vnoremap <Leader>G :<C-u>call user#rg#visual('RgNoIgnore')<CR><CR>
nnoremap <silent> <Leader>: :<C-u>History:<CR>
nnoremap <silent> <Leader>q :<C-u>botright copen<CR>
nnoremap <silent> <Leader>d :<C-u>tabnew<CR><C-o>:<C-u>Gdiffsplit<CR>
nnoremap <silent> <Leader>s
\ :<C-u>call user#win#goto_or('.git/index', 'tabnew \| Git! \| wincmd K')<CR>
nnoremap <silent> <Leader>b :<C-u>Git blame<CR>
nnoremap <silent> <Leader>B :<C-u>GBrowse<CR>
vnoremap <silent> <Leader>B :<C-u>GBrowse<CR>
nnoremap <silent> <Leader>, :<C-u>Git commit \| startinsert<CR>
nnoremap <silent> <Leader>. :<C-u>Dispatch! git push<CR>
" nmap     <silent> <Leader>n <Plug>(coc-references)
" nmap     <silent> <Leader>m <Plug>(coc-implementation)
" nnoremap <silent> <Leader>e :<C-u>CocFzfList diagnostics<CR>
" nnoremap <silent> <Leader>y :<C-u>CocFzfList symbols<CR>
nnoremap <silent> <Leader>l :<C-u>Vista!!<CR>

nmap gc <nop>
nnoremap <silent> gcc :<C-u>CamelB<CR>:call repeat#set("gcc")<CR>
nnoremap <silent> gcC :<C-u>Camel<CR>:call repeat#set("gcC")<CR>
nnoremap <silent> gcs :<C-u>Snek<CR>:call repeat#set("gcs")<CR>
nnoremap <silent> gck :<C-u>Kebab<CR>:call repeat#set("gck")<CR>
xnoremap <silent> gcc :CamelB<CR>:call repeat#set("gcc")<CR>
xnoremap <silent> gcC :Camel<CR>:call repeat#set("gcC")<CR>
xnoremap <silent> gcs :Snek<CR>:call repeat#set("gcs")<CR>
xnoremap <silent> gck :Kebab<CR>:call repeat#set("gck")<CR>

nnoremap mv :<C-u>CocCommand workspace.renameCurrentFile<CR>
" nnoremap <silent> K :call CocShowDocumentation()<CR>
inoremap <silent><expr> <Tab> pumvisible() ? coc#_select_confirm() : "\<Tab>"

noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <C-a> <Home>
noremap! <C-e> <End>
noremap! <C-d> <Del>
noremap! <C-y> <C-r>+
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-k> <C-o>D
cnoremap <expr> <C-p> pumvisible() ? "\<Left>" : "\<Up>"
cnoremap <expr> <C-n> pumvisible() ? "\<Right>" : "\<Down>"
cnoremap <C-k> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>
cnoremap <C-x> <C-r>=expand('%:p')<CR>

MyAutocmd FileType qf
\   nnoremap <buffer> ; <CR>zz<C-w>p
\ | nnoremap <silent> <buffer> dd :<C-u>call user#quickfix#del()<CR>
\ | nnoremap <silent> <buffer> u  :<C-u>call user#quickfix#undo_del()<CR>
\ | nnoremap <silent> <buffer> R  :<C-u>Qfreplace topleft split<CR>

" bulletの行でTabを押すとインデントを追加
MyAutocmd FileType markdown
\   inoremap <expr><buffer> <Tab> getline('.') =~ '^\s*- .*' ? "\<C-t>" : "\<Tab>"
\ | nmap <Leader><CR> <Plug>MarkdownPreviewToggle

call colorscheme#get()
call plugins#load()
call colorscheme#set()

let g:nightfox_debug = 1

lua require'plugins'

hi link checkedItem Comment
