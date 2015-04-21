if globpath(&rtp, "plugin/unite.vim") == ""
  echohl WarningMsg | echomsg "fastunite: unite.vim is not found." | echohl none
  finish
endif

"
" Feature Detection:
"

let s:has_neomru = globpath(&rtp, "plugin/neomru.vim") == ""
let s:has_tag = globpath(&rtp, "autoload/unite/sources/tag.vim") != ""
let s:has_ag = executable('ag')

"
" Settings:
"   some reasonable default settings.
"

let g:unite_data_directory = expand("~/.cache/unite")
let g:unite_prompt = '  →  '

if s:has_tag
  let g:unite_source_tag_max_fname_length = 70
endif

"
" Unite Marks:
"   show file marks (eg, `mA`) in unite-mark.vim, if it's available.
"

let g:unite_source_mark_marks =
  \ "abcdefghijklmnopqrstuvwxyz" .
  \ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

"
" Improved Searching:
"   Use `ag` so that file_rec will respect gitignore.
"   https://github.com/Shougo/unite.vim/issues/398#issuecomment-27012821
"

if s:has_ag
  let g:unite_source_rec_async_command =
    \ 'ag --nocolor --nogroup -g ""'
endif

"
" Tag Sorting:
"   ensure that `on_page` matches `on_page?` and not `confirmation_page`.
"   sorter_selecta would be better, but it's not as fast as sorter_rank.
"

call unite#custom#source('tag', 'sorters', ['sorter_rank'])

"
" File_rec Matchers:
"   strip off absolute paths from file_rec.
"   also, use fuzzy ctrl-p-style matcher.
"   also, neovim doesn't have ruby so... no selecta
"

let s:file_recs = 'file_rec,file_rec/async'
if s:has_tag
  let s:file_recs .= 'tag'
endif

let s:sorter = has("ruby") ? 'sorter_selecta' : 'sorter_rank'
call unite#custom#source(s:file_recs, 'sorters', [s:sorter])
call unite#custom#source(s:file_recs, 'matchers',
  \ ['converter_relative_word', 'matcher_fuzzy'])

"
" Neomru:
"   Restrict to project. unite-filter-matcher_project_files
"

if s:has_neomru
  call unite#custom#source(
    \ 'neomru/file', 'matchers',
    \ ['converter_relative_word', 'matcher_project_files', 'matcher_fuzzy'])
end

"
" Prefix Key:
"   map <leader>u as the unite prefix.
"

nnoremap [unite] <Nop>
nmap <leader>u [unite]

"
" Key Bindings:
"

" files in project (git)
nnoremap <silent> [unite]p
  \ :<C-u>Unite -buffer-name=project
  \ -resume
  \ -input=
  \ -start-insert
  \ -hide-source-names
  \ -unique
  \ file file_rec/async<CR>

" file (manual navigator)
nnoremap <silent> [unite]f
  \ :<C-u>Unite -buffer-name=file
  \ -resume
  \ -input=
  \ -start-insert
  \ -hide-source-names
  \ file file/new<CR>

" grep
nnoremap <silent> [unite]g
  \ :<C-u>Unite -buffer-name=grep
  \ -start-insert
  \ grep:.<CR>

" buffer
nnoremap <silent> [unite]b
  \ :<C-u>Unite -buffer-name=buffers
  \ -start-insert
  \ buffer<CR>

" tags
nnoremap <silent> [unite]t
  \ :<C-u>Unite -buffer-name=tag
  \ -resume
  \ -input=
  \ -start-insert
  \ tag<CR>

" outline
nnoremap <silent> [unite]o
  \ :<C-u>Unite -buffer-name=outline
  \ -auto-highlight
  \ -vertical
  \ -winwidth=30
  \ outline<CR>

if exists('g:loaded_neomru')
  " recent files
  nnoremap <silent> [unite]r
    \ :<C-u>Unite -buffer-name=mru
    \ -input=
    \ -start-insert
    \ neomru/file<CR>

  " recent dirs
  nnoremap <silent> [unite]d
    \ :<C-u>Unite -buffer-name=mrudirs
    \ -input=
    \ -start-insert
    \ -default-action=cd
    \ neomru/directory<CR>
endif

"
" Unite Tag Integration:
"   Use unite-tag instead of ^] for navigating to tags.
"   :help unite-tag-customize
"

autocmd BufEnter *
\   if empty(&buftype)
\|    nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
\| endif

"
" Improved Grep:
"   Use ag for `:Unite grep` search if available.
"   https://github.com/ggreer/the_silver_searcher
"

if s:has_ag
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
    \ '--nogroup --nocolor --column --ignore vendor --ignore public'
  let g:unite_source_grep_recursive_opt = ''
endif

if exists('*fastunite#loaded')
  call fastunite#loaded()
endif
