# vim-fastunite

The fastest way to navigate your files powered by [unite.vim]. Just press `<Ctrl-P>`.

<br>

## About

vim-fastunite is an optimized and opinionated distribution of [unite.vim].

Unite is amazing, but is so hard to configure. I've done the heavy lifting for you. Here's a sensible one-size-fits-all package to get you productive on Unite.vim.

- **Batteries included:**<br>
  Just install the vim plugins needed and `ag`, no need for complicated vimrc incantations.

- **Fast indexing:**<br>
  Uses `ag` to index your files... many orders of magnitude faster than the default.

- **Cached windows:**<br>
  Invoking Unite after the first time is instantaneous.  Unite sessions are
  cached, so pressing `,up` again will resume the previous session.

- **Preconfigured matchers:**<br>
  Fuzzy matching, smart sorting... maximum productivity.

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
