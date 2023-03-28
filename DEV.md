# 🛠️ Developer documentation

This is a documentation file for Bookmarks developers.

## Development environment setup

This section describes how to setup your development environment.

This project requires the following tools:

- [Act]
- [Commitlint]
- [fish_indent]
- [Lefthook]
- [Markdownlint]

Install Lefthook:

```shell
lefthook install
```

## Design decisions

This section describes some explicit design decisions for this tool.

### On file farmet

Bookmarks uses home-made as the file format for BFDIRS to reuse. Its desirable
benefits are:

- It's a human-readable format.
- It can be easily parsed with internal Fish tools.

### On CSV

A previous version of Bookmarks depended on [Csvkit][csvkit]. Bookmarks has
decided not to use it, because it's slow. A single call takes 100ms (compared
to microseconds for string-replaced), which leads to noticable delays.

### On encoding

I allow arbitrary strings in values, because paths can be arbitrary strings

#### Newlines

We don't accept newlines as bookmark names or values, because the current tools
don't allow clean separation of newlines that are a part of a filename and
newlines that are terminating an entry. Null delimiter support is lacking in
the ecosystem.

Implementing this in a proper programming language is out of the question,
because I don't want to deal with non-Fisher distribution.

[csvkit]: https://csvkit.readthedocs.io
[Act]: https://github.com/nektos/act
[Commitlint]: https://github.com/conventional-changelog/commitlint
[fish_indent]: https://fishshell.com/docs/current/cmds/fish_indent.html
[Lefthook]: https://github.com/evilmartians/lefthook
[Markdownlint]: https://github.com/igorshubovych/markdownlint-cli
