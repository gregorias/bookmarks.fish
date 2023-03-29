function _bf_extract_key --description 'Extracts the key from a bookmark entry'
    cat - | string replace --regex '^([^,]*),.*$' '$1'
end

function _bf_extract_value --description 'Extracts the value from a bookmark entry'
    cat - | string replace --regex '^[^,]*,(.*)$' '$1'
end

function _bf_find_bookmark_entry_by_name --description 'Finds a bookmark entry'
    cat $BFDIRS | string match "$argv[1],*"
end

# Returns the remaining database.
function _bf_delete_bookmark_entry_by_name --description 'Deletes a bookmark entry'
    cat $BFDIRS | string match --invert "$argv[1],*"
end

# A counterpart to _bf_fish_expand. For every string FOO, `[_bf_fish_expand (_bf_fish_escape FOO) = FOO]`
function _bf_fish_escape --description "Escapes a Fish string"
    echo \'"$(string replace \' \\\' $argv[1])"\'
end

# A counterpart to _bf_fish_escape.
function _bf_fish_expand --description "Expands a string using Fish"
    eval "echo $argv[1]"
end

function _bf_delete_bookmark
    function __bf_delete_bookmark_print_help
        printf "%s\n" \
            "bf delete — Delete a bookmark." \
            "" \
            "bf delete [-h | --help]" \
            "bf delete BOOKMARK" \
            "" \
            "Options:" \
            "  -h, --help" \
            "    Show this help message."
    end

    argparse h/help -- $argv

    if set -ql _flag_h
        __bf_delete_bookmark_print_help
        return 0
    end

    if [ (count $argv) -eq 0 ]
        __bf_delete_bookmark_print_help >&2
        return 1
    end
    set -f key $argv[1]

    set -l matches (_bf_find_bookmark_entry_by_name $key)
    if [ (count $matches) -eq 0 ]
        echo -e "\033[0;31mERROR: '$argv[1]' bookmark does not exist.\033[00m" >&2
        return 1
    end

    set -l tmp (mktemp)
    _bf_delete_bookmark_entry_by_name $key >$tmp
    mv $tmp $BFDIRS
end

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
    set -l key $argv[1]

    set -l matches (_bf_find_bookmark_entry_by_name $key)
    if [ (count $matches) -eq 0 ]
        echo -e "\033[0;31mERROR: '$key' bookmark does not exist.\033[00m" >&2
        return 1
    end

    set -l unexpanded_target (echo -n $matches[1] | _bf_extract_value)
    set -l target "$(_bf_fish_expand $unexpanded_target)"


    if [ -d $target ]
        cd $target
        return 0
    else
        echo -e "\033[0;31mERROR: The target directory for '$key', '$target', does not exist.\033[00m" >&2
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
            "    Show as KEY,VALUE entries without markup."
    end

    argparse h/help plain -- $argv

    if set -ql _flag_h
        __bf_list_bookmarks_print_help
        return 0
    end

    set -l TMPK (mktemp)
    set -l TMPV (mktemp)
    if set -ql _flag_plain
        cat $BFDIRS
    else
        cat $BFDIRS | _bf_extract_key | awk '/.*/{printf("\033[0;33m%-20s\033[0m \n", $0);}' >$TMPK
        cat $BFDIRS | _bf_extract_value >$TMPV
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

    if [ (count $argv) -eq 0 ]
        echo -e "\033[0;31mERROR: bookmark name required\033[00m" >&2
        return 1
    end
    set -f key $argv[1]

    set -l matches (_bf_find_bookmark_entry_by_name $key)
    if [ (count $matches) -eq 0 ]
        echo -e "\033[0;31mERROR: '$argv[1]' bookmark does not exist.\033[00m" >&2
        return 1
    end

    _bf_fish_expand (echo $matches[1] | _bf_extract_value)
end

function _bf_save_bookmark
    function __bf_save_bookmark_print_help
        printf "%s\n" \
            "bf save — Save a bookmark." \
            "" \
            "bf save [-h | --help]" \
            "bf save [OPTIONS...] BOOKMARK — Saves the CWD under BOOKMARK." \
            "bf save [OPTIONS...] BOOKMARK VALUE — Saves VALUE under BOOKMARK." \
            "" \
            "Options:" \
            "  -h, --help" \
            "    Show this help message." \
            "" \
            "  --force" \
            "    Saves the bookmark even if it already exists."
    end

    argparse h/help force -- $argv

    if set -ql _flag_h
        __bf_save_bookmark_print_help
        return 0
    end

    if [ (count $argv) -lt 1 ]
        echo -e "\033[0;31mERROR: bookmark name required.\033[00m" >&2
        return 1
    end
    set -f key $argv[1]

    # Commas are used as a delimiter between keys and values.
    if string match --entire --quiet ',' $key
        echo -e "\033[0;31mERROR: Bookmark names can not contain commas.\033[00m" >&2
        return 1
    end
    # Newlines end entries.
    if string match --entire --quiet \n $key
        echo -e "\033[0;31mERROR: Bookmark names can not contain newlines.\033[00m" >&2
        return 1
    end

    if [ (count $argv) -ge 2 ]
        set -f value $argv[2]
    else
        set -f value "$(_bf_fish_escape $PWD)"
    end

    # Newlines end entries.
    if string match --entire --quiet \n $value
        echo -e "\033[0;31mERROR: Bookmark paths can not contain newlines.\033[00m" >&2
        return 1
    end

    if cat $BFDIRS | string match --quiet "$key,*"
        if set -ql _flag_force
            set -l tmp (mktemp)
            _bf_delete_bookmark_entry_by_name $key >$tmp
            echo $key,$value >>$tmp \
                && mv $tmp $BFDIRS
            return $status
        else
            echo -e "\033[0;31mERROR: '$key' bookmark already exists. Delete it first.\033[00m" >&2
            return 1
        end
    end

    echo "$key,$value" >>$BFDIRS
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
            "  d, delete  Delete a bookmark." \
            "  g, go      Change CWD to a bookmark." \
            "  l, list    List bookmarks." \
            "  p, print   Print a bookmark's value." \
            "  s, save    Bookmark a directory."
    end

    switch $argv[1]
        case -h --help
            __bf_print_help
        case d
            _bf_delete_bookmark $argv[2..]
        case delete
            _bf_delete_bookmark $argv[2..]
        case g
            _bf_go_to_bookmark $argv[2..]
        case go
            _bf_go_to_bookmark $argv[2..]
        case l
            _bf_list_bookmarks $argv[2..]
        case list
            _bf_list_bookmarks $argv[2..]
        case p
            _bf_print_bookmark $argv[2..]
        case print
            _bf_print_bookmark $argv[2..]
        case s
            _bf_save_bookmark $argv[2..]
        case save
            _bf_save_bookmark $argv[2..]
        case '*'
            __bf_print_help
            return 1
    end
end
