set TMP (mktemp)
printf "%s\n" \
    'foo,hello, "' \
    'bar,world!' >$TMP
@test "_bf_list_keys lists keys" (_bf_list_keys $TMP | string collect) = "foo
bar"
