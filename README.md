# 📚 bookmarks.fish 🐟

A [Fish] plugin for bookmarking directories.

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

Bookmarks uses `BFDIRS` variable to point to the bookmarks file (default
`~/.bfdirs`).

The BFDIRS file is a key-value file. Each line represents a bookmark entry
(`KEY,VALUE`). Keys and values can be arbitrary strings but keys can not
contain commas.

> **Warning**
> Bookmarks doesn't support newlines in bookmark names or filenames. For more
> information, see DEV.md.

### Fish Shell Parameter Expansion

Bookmarks uses `eval` on bookmark values before using them in `bf go` and `bf
print`.

This feature allows you to support things like Git work trees:

```fish
/git-repo/foo > function current-wt
  pwd | string replace -r '/git-repo/([^/]*)/.*' '$1'
  # You can add some code here to choose a default branch if outside of
  # git-repo.
end

/git-repo/foo > bf save git-repo-tests '/git-repo/(current-wt)/tests'
/git-repo/foo > bf go git-repo-tests
/git-repo/foo/tests > cd ../../bar
/git-repo/bar > bf go git-repo-tests
/git-repo/bar/tests >
```

## 🙏 Credits

I was inspired by [Fishmarks][fishmarks]. I created Bookmarks to fix some
problems that I had with Fishmarks:

* Bookmarks has live completion that recomputes suggestions on directory
  changes.
* Bookmarks has few restrictions on bookmark names. Particularly, it allows
  hyphens and unicode characters.
* Bookmarks has one central command with completions and help.
* Bookmarks is compatible with Fish plugin managers like [Fisher][fisher].
* Bookmarks is compatible with [CLI Guidelines](https://clig.dev/). It provides
  `--plain` command versions where applicable.
* Bookmarks has no default aliases that take the prime single letter space that
  also conflict with Fasd.
* Bookmarks supports shell parameter expansion. This is useful for advanced
  cases like supporting Git work trees or monorepos.

[Fish]: https://fishshell.com/
[fisher]: https://github.com/jorgebucaran/fisher
[fishmarks]: https://github.com/techwizrd/fishmarks
