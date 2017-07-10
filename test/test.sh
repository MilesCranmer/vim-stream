#!/bin/bash
# From http://tldp.org/LDP/abs/html/debugging.html
VIMS=./vims

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

cat $TEST_DIR/test_files/python.py | $VIMS '' > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/python.py)
TEST_NUM=0
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to do a non-edit passed"

cat $TEST_DIR/test_files/python.py | $VIMS -e '^\s\+def __init__' 'V/^\\s\\+def\<enter>kdGp' | cat > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/python_init_at_bottom.py)
TEST_NUM=1
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to move init to bottom passed"

cat $TEST_DIR/test_files/python.py | $VIMS -n '$-3,$p' | cat > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/python_last_4_lines.py)
TEST_NUM=2
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to print last 4 lines passed"

cat $TEST_DIR/test_files/python.py | $VIMS -s '/^class\<enter>O# This class is for Bifrost\<esc>Go\<enter># This file does not run!' | cat > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/python_with_extra_comments.py)
TEST_NUM=3
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to do one long 'simple' command passed"

cat $TEST_DIR/test_files/python.py | $VIMS -s 'x' | cat > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/python_minus_one_char.py)
TEST_NUM=4
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to do one short 'simple' command passed"

cat $TEST_DIR/test_files/python.py | $VIMS -e '.*' ':m0\<enter>' | cat > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/python_reversed.py)
TEST_NUM=5
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to reverse a file with exe passed"

cat $TEST_DIR/test_files/python.py | $VIMS '%g/.*/m0' | cat > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/python_reversed.py)
TEST_NUM=6
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to reverse a file in normal mode passed"

cat $TEST_DIR/test_files/numbers.txt | $VIMS -e '^5$' 'dd' -t '%g/^3$/t$' | cat > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/numbers_5_gone_3_bottom.txt)
TEST_NUM=7
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to turn back off exe mode passed"

cat $TEST_DIR/test_files/numbers.txt | $VIMS -e '^5$' 'dd' -s ':%g/^3$/t$\<enter>' | cat > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/numbers_5_gone_3_bottom.txt)
TEST_NUM=8
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to run multi-mode commands passed"

cat $TEST_DIR/test_files/numbers.txt | $VIMS -l '10\<c-x>' > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/numbers_all_decreased.txt)
TEST_NUM=9
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to execute command on every line passed"

cat $TEST_DIR/test_files/numbers.txt | $VIMS -r '^1$' 'dd' > .tmp
DIFF=$(diff -b .tmp $TEST_DIR/test_files/numbers_delete_all_not_1.txt)
TEST_NUM=10
assert "$DIFF" $LINENO $TEST_NUM
echo "+ test $TEST_NUM to delete all numbers not 1 passed"

echo "+ tests all passed"
rm .tmp
