# vim-fastunite

The fastest way to navigate your files powered by [unite.vim]. Just press `Ctrl-P`. No lags.

![](http://ricostacruz.com/vim-fastunite/screencast.gif)

<br>

## About

vim-fastunite is an optimized and opinionated distribution of [unite.vim], the best Vim file matcher. It's pre-configured to give you a pleasant out-of-the-box experience with Unite.

Unite is amazing, but very hard to configure. I've done the heavy lifting for you of figuring out the best settings. Here's what you'll get:

- **Batteries included:**<br>
  Just install the vim plugins and `ag` — no need for complicated vimrc incantations.

- **Fast indexing:**<br>
  Uses `ag` to index your files. Many orders of magnitude faster than the default.

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
" ~/.vimrc
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite.vim'
Plug 'rstacruz/vim-fastunite'

Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-outline'
Plug 'tsukkee/unite-tag'

map <C-p> [unite]p
```

Install [the_silver_searcher] for faster searches. (optional, but recommended)

```sh
brew install the_silver_searcher   # OSX
apt-get install silversearcher-ag  # Ubuntu
yum install the_silver_searcher    # Fedora
```

Now press `<Ctrl-p>` in your big project.

*Only the first 3 vimrc lines are required; the other plugins are optional but recommended.*

<br>

## Usage

**Press** `,up` **to search for files in the project**.

All keys are prefixed with `<Leader>u` by default (referred to as `[unite]`). Assuming your leader key is `,` that's:

| Key      | Description                            |
| ---      | ---                                    |
| `,u` `p` | search for files in the project        |
| `,u` `g` | search in files (grep)                 |
| `,u` `t` | search for tags (requires [unite-tag]) |
| `,u` `c` | show recent files (require ([neomru])  |
| `,u` `o` | outline (requires [unite-outline])     |

**[Documentation →](doc/fastunite.txt)**

<br>

## But really, why?

So you've probably tried Unite before. You added a few lines to your vimrc to get Unite running. If you're like me, you probably used it a few times and forgot about it because it was slow.

This plugin is a bag of many tweaks to make the Unite experience more seamless. Here are a few:

* *Faster file search:* If `ag` is available, it's used for `file_rec`. 

* *Mercurial support:* by using `ag`, .hgignore and .bzrignore are supported.

* *Use better sorting:* If `+ruby` is available in your Vim build, a better sorting method (selecta) will be selected for you. This gets you better top results, saving you keystrokes.

* *Kep mappings:* all the useful key mappings are set up for you, set up conveniently with a configurable `<Leader> u` prefix.

* *Sleeker airline:* provides a more pleasant integration with airline.vim by omitting extraneous statusbar information.

* *Faster grepping:* `ag` will be used for grepping if it's available.

* *Better unite-tag integration:* if `unite-tag` is installed, it will be used as the tag browser when pressing `^]`.

* And many more.

[unite.vim]: https://github.com/Shougo/unite.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[unite-outline]: https://github.com/Shougo/unite-outline
[unite-tag]: https://github.com/tsukkee/unite-tag
[neomru]: https://github.com/Shougo/neomru.vim
[the_silver_searcher]: https://github.com/ggreer/the_silver_searcher
