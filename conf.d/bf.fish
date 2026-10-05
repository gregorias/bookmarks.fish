not set -q BFDIRS && set -gx BFDIRS $HOME/.bfdirs
# Do not run `touch` unless necessary as `touch` costs time.
test -f $BFDIRS; or touch $BFDIRS
