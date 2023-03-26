# 📚 bookmarks.fish 🐟

A [Fish] plugin for bookmarking directories.

## ⚡️ Prerequisites

To use Bookmarks, you need to install [csvkit].

## 📦 Installation

Install this plugin with [Fisher][fisher]:

```fish
fisher install gregorias/bookmarks.fish
```

## 🚀 Usage

Bookmarks installs a single command for controlling your bookmarks, `bf`.

## 🙏 Credits

I was inspired by [Fishmarks][fishmarks]. I created Bookmarks to fix some
problems that I had with Fishmarks:

* Live completion that recomputes suggestions on directory changes.
* Less restrictions on bookmark names. Particularly allow hyphens.
* One central command with completions and help.
* No default aliases that take the prime single letter space that also
  conflicts with Fasd.

[Fish]: https://fishshell.com/
[csvkit]: https://csvkit.readthedocs.io
[fisher]: https://github.com/jorgebucaran/fisher
[fishmarks]: https://github.com/techwizrd/fishmarks
