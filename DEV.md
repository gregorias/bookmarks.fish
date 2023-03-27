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

### On CSV

Bookmarks uses CSV as the file format for BFDIRS to reuse. Its desirable
benefits are:

- It's a human-readable format.
- I can easily reuse available tools ([csvkit]) to parse and query the file.

Using a custom format ala [Fishmarks][fishmarks] would mean having to implement
custom parsing and formatting logic for no benefit.

Having to depend on an external tool is not a problem for me.

### On encoding

I allow arbitrary strings in values, because paths can be arbitrary strings.
Fortunately, it's relatively easy to encode any string in CSV.

I don't allow arbitrary string keys, so that Bookmarks can run quick regexp
searches over it without worrying about escaping anything.

#### Newlines

We don't accept newlines as bookmark names or values, because the current tools
don't allow clean separation of newlines that are a part of a filename and
newlines that are terminating a CSV entry.

Implementing this in a proper programming language is out of the question,
because I don't want to deal with non-Fisher distribution.

We'll need to wait for [Csvkit to add a functionality to output CSV rows with
NULL item deliminators](https://github.com/wireservice/csvkit/issues/1196).
With that and `string split0`, we can implement newlines support.

[fishmarks]: https://github.com/techwizrd/fishmarks
[csvkit]: https://csvkit.readthedocs.io
[Act]: https://github.com/nektos/act
[Commitlint]: https://github.com/conventional-changelog/commitlint
[fish_indent]: https://fishshell.com/docs/current/cmds/fish_indent.html
[Lefthook]: https://github.com/evilmartians/lefthook
[Markdownlint]: https://github.com/igorshubovych/markdownlint-cli
