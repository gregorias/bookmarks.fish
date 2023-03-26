function bf --description "Manage Fish bookmarks"
    function __bf_print_help
        printf "%s\n" \
            "bf — Manage Fish bookmarks." \
            "" \
            "bf [-h | --help]" \
            "" \
            "Options:" \
            "  -h, --help" \
            "    Show this help message."
    end

    switch $argv[1]
        case -h --help
            __bf_print_help
        case '*'
            __bf_print_help >&2
            return 1
    end
end
