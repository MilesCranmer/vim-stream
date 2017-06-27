#!/bin/bash
# From http://tldp.org/LDP/abs/html/debugging.html
assert ()                 #  If condition false,
{                         #+ exit from script
    #+ with appropriate error message.
    E_PARAM_ERR=98
    E_ASSERT_FAILED=99


    if [ -z "$2" ]          #  Not enough parameters passed
    then                    #+ to assert() function.
        return $E_PARAM_ERR   #  No damage done.
    fi

    lineno=$2

    if [ ! $1 ] 
    then
        echo "Test assertion failed:  \"$1\""
        echo "Test \"$0\", line $lineno"    # Give name of file and line number.
        exit $E_ASSERT_FAILED
        # else
        #   return
        #   and continue executing the script.
    fi  
} # Insert a similar assert() function into a script you need to debug.    

cat test_files/python.py | ../vims -e '^\s\+def __init__' 'V/^\\s\\+def\<enter>kdGp' | cat > .tmp
DIFF=$(diff -b .tmp test_files/python_init_at_bottom.py)
rm .tmp
assert [ $DIFF == "" ] $LINENO 
echo "+ test to move init to bottom passed"
echo "+ test_exe_mode all passed"
