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

cat test_files/python.py | ../vims '' > .tmp
DIFF=$(diff -b .tmp test_files/python.py)
assert "$DIFF" $LINENO 0
echo "+ test to do a non-edit passed"

cat test_files/python.py | ../vims -e '^\s\+def __init__' 'V/^\\s\\+def\<enter>kdGp' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_init_at_bottom.py)
assert "$DIFF" $LINENO 1
echo "+ test to move init to bottom passed"

cat test_files/python.py | ../vims -n '$-3,$p' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_last_4_lines.py)
assert "$DIFF" $LINENO 2
echo "+ test to print last 4 lines passed"

cat test_files/python.py | ../vims -s '/^class\<enter>O# This class is for Bifrost\<esc>Go\<enter># This file does not run!' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_with_extra_comments.py)
assert "$DIFF" $LINENO 3
echo "+ test to do one long 'simple' command passed"

cat test_files/python.py | ../vims -s 'x' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_minus_one_char.py)
assert "$DIFF" $LINENO 3
echo "+ test to do one short 'simple' command passed"

cat test_files/python.py | ../vims -e '.*' ':m0\<enter>' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_reversed.py)
assert "$DIFF" $LINENO 4
echo "+ test to reverse a file with exe passed"

cat test_files/python.py | ../vims '%g/.*/m0' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_reversed.py)
assert "$DIFF" $LINENO 5
echo "+ test to reverse a file in normal mode passed"

cat test_files/numbers.txt | ../vims -e '^5$' 'dd' -t '%g/^3$/t$' | cat > .tmp
DIFF=$(diff -b .tmp test_files/numbers_5_gone_3_bottom.txt)
assert "$DIFF" $LINENO 6
echo "+ test to turn back off exe mode"

echo "+ tests all passed"
rm .tmp
