# 📚 bookmarks.fish 🐟

A [Fish] plugin for bookmarking directories.

## ⚡️ Prerequisites

To use Bookmarks, you need to install [csvkit].

## 📦 Installation

Install this plugin with [Fisher][fisher]:

```fish
fisher install gregorias/bookmarks.fish
```

I recommend setting up aliases in your `config.fish`:

```fish
alias d 'bf delete'
alias g 'bf go'
alias l 'bf list'
alias p 'bf print'
alias s 'bf save'
```

## 🚀 Usage

Bookmarks installs a single command for controlling your bookmarks, `bf`.

```fish
~ $ s home
~ $ cd .config/fish
.config/fish $ s fish
.config/fish $ g home
~ $ l
home       /Users/grzesiek
fish       /Users/grzesiek/.config/fish
~ $ p home
/Users/grzesiek
~ $ d fish
~ $ l
home       /Users/grzesiek
```

### BFDIRS

Bookmarks uses `BFDIRS` variable to point to the bookmarks file
(default `~/.bfdirs`).

The BFDIRS file is a key-value CSV file. Values represent directory paths
and can be arbitrary strings. Keys represent bookmark names. Keys can not
contain CSV (`"`, `,`) or regex special characters.

> **Warning**
> Bookmarks doesn't support newlines in bookmark names or filenames. For more
> information, see DEV.md.

## 🙏 Credits

I was inspired by [Fishmarks][fishmarks]. I created Bookmarks to fix some
problems that I had with Fishmarks:

* Bookmarks has live completion that recomputes suggestions on directory
  changes.
* Bookmarks has less restrictions on bookmark names. Particularly, it allows
  hyphens.
* Bookmarks has one central command with completions and help.
* Bookmarks is compatible with Fish plugin managers like [Fisher][fisher].
* Bookmarks is compatible with [CLI Guidelines](https://clig.dev/). It provides
  `--plain` command versions where applicable.
* Bookmarks has no default aliases that take the prime single letter space that
  also conflict with Fasd.

[Fish]: https://fishshell.com/
[csvkit]: https://csvkit.readthedocs.io
[fisher]: https://github.com/jorgebucaran/fisher
[fishmarks]: https://github.com/techwizrd/fishmarks
