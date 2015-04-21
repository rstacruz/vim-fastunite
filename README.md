# vim-fastunite

:construction: **Opinionated distribution of [unite.vim].**<br>

Unite is amazing but is ridiculously hard to configure. I've done all the heavy lifting for you and came up with a sensible one-size-fits-all package to get you productive on Unite.vim.

- **Fast searches:** !!<br>
  Uses `ag` when available for the fastest file finding interface available

- **Cached windows:** !!<br>
  Unite instances are cached, so pressing `,up` again will be super-fast

- **Preconfigured matchers:**<br>
  Matchers were configured and optimized to work with neovim, vim, etc.

-  Documentation to follow, please bear with us!

**[Documentation →](doc/fastunite.txt)**

<br>

## Installation

Use your favorite Vim package manager to install `vim-fastunite` with its dependencies. With [vim-plug]:

```vim
" required
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim'

" optional, but recommended
Plug 'tsukkee/unite-tag'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-outline'

Plug 'rstacruz/vim-fastunite'
```

```vim
" recommended: bind Ctrl-P
map <C-p> [unite]p
```

Optional, but recommended: install [the_silver_searcher].

```sh
brew install the_silver_searcher   # OSX
apt-get install silversearcher-ag  # Ubuntu
yum install the_silver_searcher    # Fedora
```

Now press `,up` in your big project.

<br>

## Usage

All commands are prefixed with `<Leader>u` by default. Assuming your leader key is `,` that's:

- `,up` - search for files in the project
- `,ut` - search for tags (requires [unite-tag])

Also available:

- `,ug` - search in files (grep)
- `,uo` - outline (requires [unite-outline])

<br>

## But really, why?

So you've probably tried adding a few lines to your vimrc to get Unite running. There are many other things this plugin does to make the Unite experience more seamless, including:

* Faster file search: If `ag` is available, it's used for `file_rec`. 

* Mercurial support: by using `ag`, .hgignore and .bzrignore are supported.

* Use better sorting: If ruby is available in your Vim build, a better sorting method will be selected for you

* Mappings: all the useful key mappings are set up for you

* Airline: improves integration with airline

* Faster grepping: `ag` will be used for grepping if it's available

* And many more

<br>

## Extra awesomeness

Compile your vim with `--with-lua` for faster unite.vim

[unite.vim]: https://github.com/Shougo/unite.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[unite-outline]: https://github.com/Shougo/unite-outline
[unite-tag]: https://github.com/tsukkee/unite-tag
[the_silver_searcher]: https://github.com/ggreer/the_silver_searcher
