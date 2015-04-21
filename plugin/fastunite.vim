if globpath(&rtp, "plugin/unite.vim") == ""
  echohl WarningMsg | echomsg "fastunite: unite.vim is not found." | echohl none
  finish
endif

"
" Options:
"

if !exists('g:fastunite_direction')
  let g:fastunite_direction = 'topleft'
endif

"
" Feature Detection:
"

let s:has_outline = globpath(&rtp, "autoload/unite/sources/outline.vim") != ""
let s:has_airline = globpath(&rtp, "plugin/airline.vim") != ""
let s:has_neomru = globpath(&rtp, "plugin/neomru.vim") != ""
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
  let s:file_recs .= ',tag'
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

function! s:unite_map(key1, key2, bufname, opts)
  let l:dialog = '-direction=' . g:fastunite_direction . ' '
  let l:here = '-no-split '
  let l:unite = ':<C-u>Unite -buffer-name=' . a:bufname

  exe "nnoremap <silent> [unite]" . a:key1 . ' ' . l:unite . ' ' . l:dialog . ' ' . a:opts . '<CR>'
  exe "nnoremap <silent> [unite]" . a:key2 . ' ' . l:unite . ' ' . l:here   . ' ' . a:opts . '<CR>'
endfunction

call s:unite_map('p', 'P', 'project',
  \ "-resume -input= -start-insert -hide-source-names -unique file file_rec/async")

call s:unite_map('f', 'F', 'file',
  \ "-resume -input= -start-insert -hide-source-names -unique file file/new")

call s:unite_map('g', 'G', 'grep',
  \ "-start-insert grep:.")

call s:unite_map('b', 'B', 'buffer',
  \ "-start-insert buffer")

call s:unite_map('t', 'T', 'tag',
  \ "-resume -input= -start-insert tag")

if s:has_neomru
  " recent files
  call s:unite_map('r', 'R', 'mru',
    \ "-input= -start-insert neomru/file")

  " recent dirs
  call s:unite_map('d', 'D', 'dirs',
    \ "-input= -start-insert -default-action=cd neomru/directory")
endif

if s:has_outline
  " outline
  nnoremap <silent> [unite]o
    \ :<C-u>Unite -buffer-name=outline
    \ -auto-highlight
    \ -vertical
    \ -winwidth=30
    \ outline<CR>
endif

"
" Unite Tag Integration:
"   Use unite-tag instead of ^] for navigating to tags.
"   :help unite-tag-customize
"

autocmd BufEnter *
\   if empty(&buftype)
\|    nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -buffer-name=tag -immediately tag<CR>
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

"
" Airline Integration:
"   simplifies the status line and gets rid of the unnecessary cruft
"   for airline.vim.
"
"   from:
"     Unite > project > file(25) file_rec/async(31) | directory: /Users/...
"
"   to:
"     Unite > project
"

if s:has_airline
  function! airline#extensions#unite#apply(...)
    if &ft == 'unite'
      call a:1.add_section('airline_a', ' Unite ')
      call a:1.add_section('airline_b', ' %{get(unite#get_context(), "buffer_name", "")} ')
      call a:1.add_section('airline_c', ' ')
      return 1
    endif
  endfunction
endif

"
" Loaded Hook:
"   allow the user to override some settings with a custom function
"

if exists('*fastunite#loaded')
  call fastunite#loaded()
endif

"
" Buffer Keys:
"   custom mappings for the unite buffer.
"   http://www.codeography.com/2013/06/17/replacing-all-the-things-with-unite-vim.html
"

autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1

  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction
