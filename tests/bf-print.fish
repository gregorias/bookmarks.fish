set BFDIRS (mktemp)
echo "foo,\"$BFDIRS\"" >$BFDIRS

bf print bar 2>/dev/null
@test "bf print returns an error on non-existent bookmark" $status -eq 1

@test "bf print prints a bookmark's value" (bf print foo) = $BFDIRS
