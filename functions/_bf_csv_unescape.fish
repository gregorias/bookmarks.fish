# Unescapes a CSV field.
#
# $ [ (echo '"hello,"""' | _bf_csv_unescape) = 'hello,"' ]
# $ [ (echo '"hello"'    | _bf_csv_unescape) = hello ]
function _bf_csv_unescape
    sed -E 's/^"(.*)"/\1/' | sed -E 's/""/"/'
end
