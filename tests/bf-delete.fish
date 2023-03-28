set BFDIRS (mktemp)
set FOO (mktemp -d)
set BAR (mktemp -d)
echo "foo,$FOO" >$BFDIRS
echo "bar,$BAR" >>$BFDIRS

bf delete foo
bf delete bar
@test "bf delete leaves BFDIRS empty" -e $BFDIRS
