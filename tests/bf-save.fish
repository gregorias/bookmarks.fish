set BFDIRS (mktemp)
set FOO (mktemp -d)
set BAR (mktemp -d)
echo "foo,\"$FOO\"" >$BFDIRS
echo "bar,\"$BAR\"" >>$BFDIRS

cd $FOO
bf save bar 2>/dev/null
@test "bf save does not overwrite existing bookmarks" $status -ne 0

set BAZ (mktemp -d)
cd $BAZ
bf save baz 2>/dev/null
@test "bf saves new directories" (bf print baz) = $BAZ
