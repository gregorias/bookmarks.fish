set -l commands go
complete -c bf -f
complete -c bf -f -sh -lhelp
complete -c bf -n "not __fish_seen_subcommand_from $commands" -a $commands
complete -c bf -n "__fish_seen_subcommand_from go" -sh -lhelp
complete -c bf -n "__fish_seen_subcommand_from go" -a "(_bf_list_keys $BFDIRS)"
