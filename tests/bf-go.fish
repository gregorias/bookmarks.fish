set BFDIRS (mktemp)
touch $BFDIRS
set TMPDIR (mktemp -d)

bf go bar 2>/dev/null
@test "bf go returns an error on non-existent directory" $status -eq 1

echo "foo,$BFDIRS" >$BFDIRS
@test "bf go returns an error if target not a directory" (bf go foo 2>/dev/null) $status -eq 1

echo "foo,$TMPDIR" >$BFDIRS
bf go foo
@test "bf go changes directory" (pwd) = "$TMPDIR"

# Completions
true >$BFDIRS
bf save bar /bar
bf save foo /foo

@test "bf go completion suggests help options" \
    (complete -C 'bf go -' | string collect) = "-h"\n"--help"
@test "bf go completion suggests keys with hints" (complete -C 'bf go ' | string collect) = bar\t/bar\nfoo\t/foo
