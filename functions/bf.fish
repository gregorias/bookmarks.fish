function _bf_go_to_bookmark
    function __bf_go_to_bookmark_print_help
        printf "%s\n" \
            "bf go — Go to a bookmark." \
            "" \
            "bf go [-h | --help]" \
            "bf go BOOKMARK" \
            "" \
            "Options:" \
            "  -h, --help" \
            "    Show this help message."
    end

    argparse h/help -- $argv

    if set -ql _flag_h
        __bf_go_to_bookmark_print_help
        return 0
    end

    if [ (count $argv) -eq 0 ]
        __bf_go_to_bookmark_print_help >&2
        return 1
    end

    set -l matches (cat $BFDIRS | csvgrep -H -c1 --regex "^$argv[1]\$" | csvcut -c2)
    if [ (printf "%s\n" $matches | wc -l) -le 1 ]
        echo -e "\033[0;31mERROR: '$argv[1]' bookmark does not exist.\033[00m" >&2
        return 1
    end

    set -l target (printf "%s\n" $matches | tail -n1 | _bf_csv_unescape)

    if [ -d $target ]
        cd $target
        return 0
    else
        echo -e "\033[0;31mERROR: The target directory for '$argv[1]', '$target', does not exist.\033[00m" >&2
        return 1
    end
end

function bf --description "Manage Fish bookmarks"
    function __bf_print_help
        printf "%s\n" \
            "bf — Manage Fish bookmarks." \
            "" \
            "bf [-h | --help]" \
            "bf <command>" \
            "" \
            "Options:" \
            "  -h, --help" \
            "    Show this help message." \
            "" \
            "Commands:" \
            "  go      Change CWD to a bookmark."
    end

    switch $argv[1]
        case -h --help
            __bf_print_help
        case go
            _bf_go_to_bookmark $argv[2..]
        case '*'
            __bf_print_help
            return 1
    end
end
