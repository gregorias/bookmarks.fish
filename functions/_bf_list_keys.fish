# Lists bookmark keys from the provided CSV file.
function _bf_list_keys
    csvcut -c1 $argv[1]
end
