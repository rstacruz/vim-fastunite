# vim-fastunite

**Opinionated distribution of [unite.vim].**<br>
:construction: **WIP:** Documentation to follow, please bear with us!

<br>

## Install

Use your favorite Vim package manager to install `vim-fastunite` with its dependencies. With [vim-plug]:

```vim
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim'
Plug 'tsukkee/unite-tag'
Plug 'Shougo/unite-outline'

Plug 'rstacruz/vim-fastunite'

" recommended: bind Ctrl-P
map <C-p> [unite]p
```

Optional, but recommended: install [the_silver_searcher].

```sh
brew install the_silver_searcher   # OSX
apt-get install silversearcher-ag  # Ubuntu
yum install the_silver_searcher    # Fedora
```

<br>

## Usage

All commands are prefixed with `<Leader>u` by default. Assuming your leader key is `,` that's:

- `,up` - search for files in the project
- `,ut` - search for tags (requires [unite-tag])

Also available:

- `,ug` - search in files (grep)
- `,uo` - outline (requires [unite-outline])

<br>

## Why?

- **Fast searches:** !!<br>
  Uses `ag` when available for the fastest file finding interface available

- **Cached windows:** !!<br>
  Unite instances are cached, so pressing `,ut` again will be super-fast

- **Preconfigured matchers:**<br>
  Matchers were configured and optimized to work with neovim, vim, etc.

<br>

## Extra awesomeness

Compile your vim with `--with-lua` for faster unite.vim

[unite.vim]: https://github.com/Shougo/unite.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[unite-outline]: https://github.com/Shougo/unite-outline
[unite-tag]: https://github.com/tsukkee/unite-tag
[the_silver_searcher]: https://github.com/ggreer/the_silver_searcher
