function __bf_list_bookmarks_for_completion
    cat $argv[1] | string replace --filter --regex '^([^,]*),(.*)$' '$1'\t'$2'
end
set -l commands 'delete go list print save'
complete -c bf -f
complete -c bf -f -sh -lhelp
complete -c bf -n "not __fish_seen_subcommand_from $commands" -a $commands
complete -c bf -n "__fish_seen_subcommand_from delete" -sh -lhelp
complete -c bf -n "__fish_seen_subcommand_from delete" -a "(__bf_list_bookmarks_for_completion $BFDIRS)"
complete -c bf -n "__fish_seen_subcommand_from go" -sh -lhelp
complete -c bf -n "__fish_seen_subcommand_from go" -a "(__bf_list_bookmarks_for_completion $BFDIRS)"
complete -c bf -n "__fish_seen_subcommand_from list" -sh -lhelp
complete -c bf -n "__fish_seen_subcommand_from list" -lplain
complete -c bf -n "__fish_seen_subcommand_from print" -sh -lhelp
complete -c bf -n "__fish_seen_subcommand_from print" -a "(_bf_list_keys $BFDIRS)"
complete -c bf -n "__fish_seen_subcommand_from save" -sh -lhelp
complete -c bf -n "__fish_seen_subcommand_from save" -lforce
