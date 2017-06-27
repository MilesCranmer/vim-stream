#!/bin/bash
# From http://tldp.org/LDP/abs/html/debugging.html
assert ()
{
    E_PARAM_ERR=98
    E_ASSERT_FAILED=99
    if [ -z "$2" ]
    then
        return $E_PARAM_ERR
    fi
    POINTED_LINE_NO=$2
    if [ ! -z "$1" ]
    then
        echo -n "- test assertion failed!"
        echo -n " test $3, line $POINTED_LINE_NO, "
        echo "diff between output and expected:"
        echo "$1"
        exit $E_ASSERT_FAILED
    fi
}

cat test_files/python.py | ../vims -e '^\s\+def __init__' 'V/^\\s\\+def\<enter>kdGp' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_init_at_bottom.py)
rm .tmp
assert "$DIFF" $LINENO 0
echo "+ test to move init to bottom passed"

cat test_files/python.py | ../vims -n '$-3,$p' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_last_4_lines.py)
rm .tmp
assert "$DIFF" $LINENO 1
echo "+ test to print last 4 lines passed"

echo "+ tests all passed"
