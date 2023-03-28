set BFDIRS (mktemp)
touch $BFDIRS

set TMPDIR (mktemp -d)
mkdir $TMPDIR/'$(pwd), \'""'
cd $TMPDIR/'$(pwd), \'""'

bf save special
cd ..
bf go special
@test "bf can save and go directories with special names" "$(pwd)" = $TMPDIR/'$(pwd), \'""'

true >$BFDIRS
bf save special2 '/baz/(echo foo)"bar"'
@test "bf handles (echo foo) command substitution" (bf print special2) = /baz/foobar
