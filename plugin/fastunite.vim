" Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker:
    " Personal unite conifig of Mario Carballo Zama
    " Arlefreak
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    " AAAAAAAAAAA~                     AAAAAA
    " AAAAAAAAAAAAA          .AAAAA.   AAAAAA
    " AAAAAA AAAAAAAA       .AAAAAAA.  AAAAAA
    " AAAAAA  DAAAAAAA      .AAAAAAA.  AAAAAA
    " AAAAAA    AAAAAAAA     AAAAAAA   AAAAAA
    " AAAAAA     IAAAAAAAO    AAAAA    AAAAAA
    " AAAAAA       DAAAAAAA            AAAAAA
    " AAAAAA         AAAAAAAD          AAAAAA
    " AAAAAA          AAAAAAAA         AAAAAA      arlefreak.com
    " AAAAAAAAAAAAAAAAAAAAAAAAAA       AAAAAA
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAD     AAAAAA
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAAA    AAAAAA
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  AAAAAA
    " AAAAAA                  AAAAAAAA AAAAAA
    " AAAAAA                    AAAAAAAAAAAAA
    " AAAAAA                      AAAAAAAAAAA
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
" }

" Feature check {
    if globpath(&rtp, "plugin/unite.vim") == ""
      echohl WarningMsg | echomsg "unite-config: unite.vim is not found." | echohl none
      finish
    endif


    "
    " Feature Detection:
    "

    let s:has_outline = globpath(&rtp, "autoload/unite/sources/outline.vim") != ""
    let s:has_airline = globpath(&rtp, "plugin/airline.vim") != ""
    let s:has_neomru = globpath(&rtp, "plugin/neomru.vim") != ""
    let s:has_tag = globpath(&rtp, "autoload/unite/sources/tag.vim") != ""
    let s:has_marks = globpath(&rtp, "autoload/unite/sources/mark.vim") != ""
    let s:has_ag = executable('ag')

" }

" Settings {
    let g:unite_data_directory = expand("~/.cache/unite")
    let g:unite_prompt = '→ '
    hi link uniteInputPrompt Special

    if !exists('g:unite-config-default-options')
      let g:fastunite_default_options = { }
    endif

    if s:has_tag
      let g:unite_source_tag_max_fname_length = 70
    endif

    if s:has_ag
        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_default_opts = '--vimgrep'
        let g:unite_source_grep_recursive_opt = ''
    endif

    " Airline {
        "   simplifies the status line and gets rid of the unnecessary cruft
        "   for airline.vim.
        "
        "   from:
        "     Unite > project > file(25) file_rec/async(31) | directory: /Users/...
        "
        "   to:
        "     Unite > project

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
    " }
" }

" Sources {
    " Marks {
    "   show file marks (eg, `mA`) in unite-mark.vim, if it's available.

        if s:has_marks
            let g:unite_source_mark_marks =
                  \ "abcdefghijklmnopqrstuvwxyz" .
                  \ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                  \ "0123456789.'`^<>[]{}()\""
       endif
    " }

    " Searcher (Ag) {
        if s:has_ag
          let g:unite_source_rec_async_command =
                \ [
                \ 'ag', 
                \ '--follow',
                \ '--nocolor',
                \ '--nogroup',
                \ '--hidden',
                \ '-g', 
                \ ''
                \ ]
        endif
    " }

    " Tag Sorting {
        " ensure that `on_page` matches `on_page?` and not `confirmation_page`.
        " sorter_selecta would be better, but it's not as fast as sorter_rank.

        call unite#custom#source('tag', 'sorters', ['sorter_rank'])
    " }

    " File_rec {
        " strip off absolute paths from file_rec.
        " also, use fuzzy ctrl-p-style matcher.
        " also, neovim doesn't have ruby so... no selecta

        let s:file_recs = 'file,directory,file_rec,file_rec/async'

        if s:has_tag
            let s:file_recs .= ',tag'
        endif

        let s:sorter = has("ruby") ? 'sorter_selecta' : 'sorter_rank'
        call unite#custom#source(s:file_recs, 'sorters', [s:sorter])
        call unite#custom#source(s:file_recs, 'matchers',
              \ ['converter_relative_word', 'matcher_fuzzy'])
    " }

    " Neomru {
        " Restrict to project. unite-filter-matcher_project_files

        if s:has_neomru
            call unite#custom#source(
                \ 'neomru/file',
                \ 'matchers',
                \ [
                \ 'converter_relative_word',
                \ 'matcher_project_files',
                \ 'matcher_fuzzy'
                \ ])
        end
  " }

" }

" Key Mappings {
    " Prefix {
        nnoremap [unite] <nop>
        nmap <leader>u [unite]
    " }

    nnoremap <silent> [unite]g :<C-u>UniteWithInput grep:.<CR>
    nnoremap <silent> [unite]G :<C-u>UniteResume grep<CR>

    nnoremap <silent> [unite]p
        \ :<C-u>Unite
        \ -resume 
        \ -buffer-name=project
        \ -no-restore
        \ -input=
        \ -start-insert
        \ -hide-source-names
        \ -unique
        \ file directory file_rec/async:!<CR>

    nnoremap <silent> [unite]f
        \ :<C-u>Unite
        \ -resume
        \ -buffer-name=file
        \ -no-restore
        \ -input= 
        \ -start-insert
        \ -hide-source-names
        \ -uniqu
        \ file/new<CR>

    nnoremap <silent> [unite]l
        \ :<C-u>Unite
        \ line<CR>

    nnoremap <silent> [unite]y
        \ :<C-u>Unite
        \ -buffer-name=Yank
        \ -no-split
        \ history/yank<CR>

    nnoremap <silent> [unite]b
        \ :<C-u>Unite
        \ -auto-resize
        \ -quick-match
        \ buffer<CR>

    nnoremap <silent> [unite]t
        \ :<c-u>Unite
        \ tag<cr>

    nnoremap <silent> [unite]n
        \ :<c-u>Unite
        \ dein<cr>

    " nnoremap <silent> [unite]N
    "     \ :<c-u>Unite
    "     \ dein/update<cr>

    if s:has_outline
        nnoremap <silent> [unite]o
            \ :<C-u>Unite 
            \ outline<CR>
    endif

    if s:has_neomru
        nnoremap <silent> [unite]r
            \ :<C-u>Unite 
            \ neomru/file<CR>
        nnoremap <silent> [unite]d
            \ :<C-u>Unite 
            \ neomru/directory<CR>
    endif


    " Buffer Keys {
        " custom mappings for the unite buffer.
        " http://www.codeography.com/2013/06/17/replacing-all-the-things-with-unite-vim.html

        autocmd FileType unite call s:unite_settings()
        function! s:unite_settings()
            " Play nice with supertab
            let b:SuperTabDisabled=1

            " Enable navigation with control-j and control-k in insert mode
            imap <buffer> <C-j>   <Plug>(unite_select_next_line)
            imap <buffer> <C-k>   <Plug>(unite_select_previous_line)

            " Restart for glitches
            imap <buffer> <C-r>   <Plug>(unite_restart)

            " Tab to drill-down (app <tab> ass <tab> sty <tab>)
            " remap old tab to C-z
            imap <buffer> <Tab>   <C-e>
            imap <buffer> <C-z>   <Plug>(unite_choose_action)
        endfunction

    " }
" }

" Profiles {
    call unite#custom#profile('default', 'context', extend({
            \ 'direction' : 'topleft',
            \ 'prompt' : unite_prompt,
        \ }, g:fastunite_default_options))

    call unite#custom#profile('source/grep', 'context', {
            \ 'buffer_name' : 'grep',
            \ 'no_quit' : 0
        \ })

    call unite#custom#profile('source/buffer', 'context', {
            \ 'buffer_name' : 'buffer',
            \ 'quick-match' : 1,
            \ 'auto-resize' : 1
        \ })

    call unite#custom#profile('source/tag', 'context', {
            \ 'buffer_name' : 'tag',
            \ 'start_insert' : 1,
            \ 'resume' : 1,
            \ 'input' : 'tag'
        \ })

    call unite#custom#profile('source/neomru/file', 'context', {
            \ 'buffer_name' : 'mru',
            \ 'start_insert' : 1
        \ })

    call unite#custom#profile('source/neomru/directory', 'context', {
            \ 'buffer_name' : 'dirs',
            \ 'start_insert' : 1,
            \ 'default_action' : 'cd'
        \ })

    call unite#custom#profile('source/outline', 'context', {
            \ 'buffer_name' : 'outline',
            \ 'start_insert' : 1,
            \ 'auto-highlight' : 1,
            \ 'vertical' : 1,
            \ 'winwidth' : 30
        \ })

    call unite#custom#profile('source/line', 'context', {
            \ 'buffer_name' : 'search',
            \ 'start_insert' : 1,
            \ 'no-split' : 1
        \ })

    call unite#custom#profile('source/histor/yank', 'context', {
            \ 'buffer_name' : 'yank',
            \ 'start_insert' : 0,
            \ 'auto-highlight' : 1,
            \ 'vertical' : 1,
            \ 'winwidth' : 30,
            \ 'no-split' : 1
        \ })

    call unite#custom#profile('source/file_rec', 'context', {
            \ 'buffer_name' : 'project',
            \ 'start_insert' : 1,
            \ 'unique' : 1,
            \ 'no-restore' : 1,
            \ 'hide-sources-names' : 1
        \ })

    call unite#custom#profile('source/file', 'context', {
            \ 'buffer_name' : 'file',
            \ 'start_insert' : 1,
            \ 'unique' : 1,
            \ 'no-restore' : 0,
            \ 'hide-sources-names' : 1
        \ })
" }

" Sources {
    set wildignore+=vendor/bundle/**
    set wildignore+=node_modules/**
    set wildignore+=bower_components/**
    set wildignore+=.git/**
    set wildignore+=*.meta
    set wildignore+=*.prefab
    set wildignore+=*.sample
    set wildignore+=*.asset
    set wildignore+=*.unity
    set wildignore+=*.anim
    set wildignore+=*.controller
    set wildignore+=*.jpg
    set wildignore+=*.png
    set wildignore+=*.mp3
    set wildignore+=*.wav
    set wildignore+=*.ttf
    call unite#custom#source('file_rec/async,file_rec/git', 'ignore_globs', split(&wildignore, ','))
" }
