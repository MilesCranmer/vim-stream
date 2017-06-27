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
    if [ ! $1 ]
    then
        echo -n "Test assertion failed:  \"$1\","
        echo "Test \"$0\", line $POINTED_LINE_NO"
        exit $E_ASSERT_FAILED
    fi
}

cat test_files/python.py | ../vims -e '^\s\+def __init__' 'V/^\\s\\+def\<enter>kdGp' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_init_at_bottom.py)
rm .tmp
assert [ $DIFF == "" ] $LINENO 
echo "+ test to move init to bottom passed"
echo "+ test_exe_mode all passed"
