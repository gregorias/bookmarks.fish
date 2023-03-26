@test "_bf_csv_unescape 1" (echo '"hello"'     | _bf_csv_unescape) = hello
@test "_bf_csv_unescape 2" (echo '"hello,"""'  | _bf_csv_unescape) = 'hello,"'
