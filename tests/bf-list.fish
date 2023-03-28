set BFDIRS (mktemp)
set FOO (mktemp -d)
set BAR (mktemp -d)
echo "foo,$FOO" >$BFDIRS
echo "bar,$BAR" >>$BFDIRS

@test "bf list prints directories" (bf list | string collect) = "[0;33mfoo                 [0m  $FOO
[0;33mbar                 [0m  $BAR"
