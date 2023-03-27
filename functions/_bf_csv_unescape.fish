# $ [ (echo '"hello,"""' | _bf_csv_unescape) = 'hello,"' ]
# $ [ (echo '"hello"'    | _bf_csv_unescape) = hello ]
function _bf_csv_unescape --description "Unescapes a CSV field"
    sed -E 's/^"(.*)"/\1/' | sed -E 's/""/"/g'
end
