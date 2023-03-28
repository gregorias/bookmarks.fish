function _bf_list_keys --description 'Lists bookmark keys'
    cat $argv[1] | string replace --filter --regex '^([^,]*),.*$' '$1'
end
