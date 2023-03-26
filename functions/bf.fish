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

    argparse h/help plumbing -- $argv

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

function _bf_list_bookmarks
    function __bf_list_bookmarks_print_help
        printf "%s\n" \
            "bf list — List bookmarks." \
            "" \
            "bf list [OPTIONS...]" \
            "" \
            "Options:" \
            "  -h, --help" \
            "    Show this help message." \
            "" \
            "  --plain" \
            "    Show as a CSV file."
    end

    argparse h/help plain -- $argv

    if set -ql _flag_h
        __bf_list_bookmarks_print_help
        return 0
    end

    set -l TMPK (mktemp)
    set -l TMPV (mktemp)
    if set -ql _flag_plain
        cat $BFDIRS | csvcut -H -c1 | tail -n+2 >$TMPK
        cat $BFDIRS | csvcut -H -c2 | tail -n+2 | _bf_csv_unescape >$TMPV
        paste -d"," $TMPK $TMPV
    else
        cat $BFDIRS | csvcut -H -c1 | tail -n+2 | awk '/.*/{printf("\033[0;33m%-20s\033[0m \n", $0);}' >$TMPK
        cat $BFDIRS | csvcut -H -c2 | tail -n+2 | _bf_csv_unescape >$TMPV
        paste -d" " $TMPK $TMPV
    end
    rm $TMPV
    rm $TMPK
end

function _bf_print_bookmark
    function __bf_print_bookmark_print_help
        printf "%s\n" \
            "bf print — Print a bookmark." \
            "" \
            "bf print [-h | --help]" \
            "bf print [OPTIONS...] BOOKMARK — Prints BOOKMARK's value." \
            "" \
            "Options:" \
            "  -h, --help" \
            "    Show this help message."
    end

    argparse h/help csv -- $argv

    if set -ql _flag_h
        __bf_print_bookmark_print_help
        return 0
    end

    if [ (count $argv) -lt 1 ]
        echo -e "\033[0;31mERROR: bookmark name required\033[00m" >&2
        return 1
    end

    set -l matches (cat $BFDIRS | csvgrep -H -c1 --regex "^$argv[1]\$" | csvcut -c2)
    if [ (printf "%s\n" $matches | wc -l) -le 1 ]
        echo -e "\033[0;31mERROR: '$argv[1]' bookmark does not exist.\033[00m" >&2
        return 1
    end

    cat $BFDIRS | grep $argv[1], | csvcut -H -c2 | tail -n+2 | _bf_csv_unescape
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
            "  go      Change CWD to a bookmark." \
            "  list    List bookmarks." \
            "  print   Print a bookmark's value."
    end

    switch $argv[1]
        case -h --help
            __bf_print_help
        case go
            _bf_go_to_bookmark $argv[2..]
        case list
            _bf_list_bookmarks $argv[2..]
        case print
            _bf_print_bookmark $argv[2..]
        case '*'
            __bf_print_help
            return 1
    end
end
