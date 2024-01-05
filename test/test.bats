#!/usr/bin/env bats

setup() {
    load "test_helper/bats-support/load"
    load "test_helper/bats-assert/load"

    DIR=$(dirname "${BATS_TEST_FILENAME}")
    TEST_DIR=${TEST_DIR:-$DIR}
    VIMS=${VIMS:-$DIR/../vims}
}

teardown() {
    rm -f .tmp
}

@test "Identity" {
    run cat $TEST_DIR/test_files/python.py | run $VIMS '' > .tmp
    run diff -b .tmp $TEST_DIR/test_files/python.py
    assert_output ""
}

@test "Move init to bottom" {
    run cat $TEST_DIR/test_files/python.py | run $VIMS -e '^\s\+def __init__' 'V/^\\s\\+def\<enter>kdGp' | run cat > .tmp
    run diff -b .tmp $TEST_DIR/test_files/python_init_at_bottom.py
    assert_output ""
}

@test "Print last 4 lines" {
    run cat $TEST_DIR/test_files/python.py | run $VIMS -n '$-3,$p' | run cat > .tmp
    run diff -b .tmp $TEST_DIR/test_files/python_last_4_lines.py
    assert_output ""
}

@test "Do one long 'simple' command" {
    run cat $TEST_DIR/test_files/python.py | run $VIMS -s '/^class\<enter>O# This class is for Bifrost\<esc>Go\<enter># This file does not run!' | run cat > .tmp
    run diff -b .tmp $TEST_DIR/test_files/python_with_extra_comments.py
    assert_output ""
}

@test "Do one short 'simple' command" {
    run cat $TEST_DIR/test_files/python.py | run $VIMS -s 'x' | run cat > .tmp
    run diff -b .tmp $TEST_DIR/test_files/python_minus_one_char.py
    assert_output ""
}

@test "Reverse a file with exe" {
    run cat $TEST_DIR/test_files/python.py | run $VIMS -e '.*' ':m0\<enter>' | run cat > .tmp
    run diff -b .tmp $TEST_DIR/test_files/python_reversed.py
    assert_output ""
}

@test "Reverse a file in normal mode" {
    run cat $TEST_DIR/test_files/python.py | run $VIMS '%g/.*/m0' | run cat > .tmp
    run diff -b .tmp $TEST_DIR/test_files/python_reversed.py
    assert_output ""
}

@test "Turn back off exe mode" {
    run cat $TEST_DIR/test_files/numbers.txt | run $VIMS -e '^5$' 'dd' -t '%g/^3$/t$' | run cat > .tmp
    run diff -b .tmp $TEST_DIR/test_files/numbers_5_gone_3_bottom.txt
    assert_output ""
}

@test "Run multi-mode commands" {
    run cat $TEST_DIR/test_files/numbers.txt | run $VIMS -e '^5$' 'dd' -s ':%g/^3$/t$\<enter>' | run cat > .tmp
    run diff -b .tmp $TEST_DIR/test_files/numbers_5_gone_3_bottom.txt
    assert_output ""
}

@test "Execute command on every line" {
    run cat $TEST_DIR/test_files/numbers.txt | run $VIMS -l '10\<c-x>' > .tmp
    run diff -b .tmp $TEST_DIR/test_files/numbers_all_decreased.txt
    assert_output ""
}

@test "Delete all numbers not 1" {
    run cat $TEST_DIR/test_files/numbers.txt | run $VIMS -r '^1$' 'dd' > .tmp
    run diff -b .tmp $TEST_DIR/test_files/numbers_delete_all_not_1.txt
    assert_output ""
}
