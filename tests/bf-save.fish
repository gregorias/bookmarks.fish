set BFDIRS (mktemp)
set FOO (mktemp -d)
set BAR (mktemp -d)
echo "foo,\"$FOO\"" >$BFDIRS
echo "bar,\"$BAR\"" >>$BFDIRS

cd $FOO
bf save bar 2>/dev/null
@test "bf save does not overwrite existing bookmarks" $status -ne 0

bf save bar\n 2>/dev/null
@test "bf save does not accept newlines in bookmark names" $status -ne 0

mkdir 'newline'\n'path'
cd 'newline'\n'path'
bf save newlinepath 2>/dev/null
@test "bf save does not accept newlines in paths" $status -ne 0

set BAZ (mktemp -d)
cd $BAZ
bf save baz 2>/dev/null
@test "bf saves new directories" (bf print baz) = $BAZ

true >$BFDIRS
bf save baz /foobar
@test "bf saves provided values" (bf print baz) = /foobar
