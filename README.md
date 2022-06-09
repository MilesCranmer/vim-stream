# vims 

[![CI](https://github.com/MilesCranmer/vim-stream/actions/workflows/CI.yml/badge.svg)](https://github.com/MilesCranmer/vim-stream/actions/workflows/CI.yml) [![Codecov branch](https://img.shields.io/codecov/c/github/MilesCranmer/vim-stream/master.svg)](https://codecov.io/gh/MilesCranmer/vim-stream)

![Demo](https://i.imgur.com/dntK3MP.gif)


Ever wish you could simply apply a vim command to every line
in a command output automatically?
If you use vim as your primary editor, this is likely much much easier
than having to look up sed commands every time you filter a command output.

E.g., `cat file.txt | vims -l 'f|d$'` will go through every line, and run "f|d$",
which is the vim command for deleting every character after "|". 
See below for many other useful features.

# Install 

To install, put `vims` somewhere on your path, e.g., `/usr/bin`.


# Usage

`... | vims [...]`
- (default) `-t [EX_CMD]` Ex mode. Works as if you typed ":" in vim.
- `-s [CMD]` Simple command mode. Starts on the first line in command mode (e.g., `x` deletes a char).
- `-l [CMD]` Line command mode. Runs the command on every line. 
- `-e [REGEX] [CMD]` Exe mode. Runs the command on every line matching `REGEX` (uses vim regex).
- `-r [REGEX] [CMD]` Inverse exe mode. Runs the command on every line not matching `REGEX` (uses vim regex).
- `-n` quiet. Don't print lines to stdout. You will then have to use `:p` command to print manually.

Note that for commands, you can write `\<esc>` to hit the escape key, or `\<c-o>` to hit ctrl-O.

```
{command} | vims [-n|--quiet]
                 [-e|--exe-mode] [-r|--inverse-exe-mode]
                 [-s|--simple-mode] [-l|--line-exe-mode]
                 [-t|--turn-off-mode]
                 [ <args>... ]
```

Call `vims` on piped input, providing a list of arguments that you
would use in vim command-line mode. All lines not deleted are printed
by default, but you can turn this off with a `-n|--quiet` flag.

## Discussion:

Trigger "exe" mode using the `-e|--exe-mode` flag, which creates macros
for `'%g/$1/exe "norm $2"'` (see [the power of `:g`](http://vim.wikia.com/wiki/Power_of_g)),
where `$1` is the first arg of a pair,
and `$2` is the last arg of a pair. This lets you type non-text characters,
like `\<esc>`, `\<c-o>`, etc.

Likewise, `-l|--line-exe-mode` translates to `%g/.*/exe "norm$1"`, meaning
it executes a command on ALL lines.

Inverse exe mode is done with the `-r|--inverse-exe-mode` flag, which
does the same as exe mode, but only on lines NOT matching the regex.

Use simple mode with the `-s|--simple-mode` flag, which is as vanilla
as it gets. This translates every passed argument to: `exe "norm $1"`, meaning
that you can run commands just like you opened the editor, starting
at line 1. Use the same backslashes (`\<enter>`) as you do for exe mode.

Modes are activated for all the proceeding args. You can switch
modes partway, by calling the flag for the other mode you want, or you
can turn off any activated mode with `-t|--turn-off-mode`.

## Example 1
Delete lines 10-15, and print the remainder:

```
cat myfile.txt | vims '10,15d'
```

- `10,15` - A range from 10-15 - see `:help :range` in vim for a huge number of options.
- `d` - The delete (from ex) command - see `:help :d` in vim.

## Example 2
Delete blank lines, then lower-case everything:

```
cat mylog.log | vims -e '^\s*$' 'dd' '.' 'Vu'
```

- `-e` - Turn on exe mode
- `^\s*$` - Line only containing whitespace
- `dd` - Delete it.
- `.` - Line containing anything (Every pair of arguments triggers a new `exe` command)
- `Vu` - Select the line, then lower-case all alphabetical characters

Or, with line exe mode (a shorthand for `.*`):

```
cat mylog.log | vims -e '^\s*$' 'dd' -l 'Vu'
```

- `-l` - Turn off exe mode, turn on line exe mode

## Example 3

Add a comment (`#`) on every line NOT containing foo:

```
cat script.sh | vims -r 'foo' 'A # Comment'
```

- `-r` - Work on all lines not matching regex
- `foo` - Match all lines with the word "foo"
- `A # Comment` - At the end of the line, type " # Comment"

## Example 4

Delete all modifications to files in a git repo:

```
git status | vims '1,/modified/-1d' '$?modified?,$d' -l 'df:dw' | xargs git checkout --
```

- `git status` - View which files are modified
- `vims` - Start vims in normal mode
- `1,/modified/-1d` - Delete all lines up to the first line with "modified"
- `$?modified?+1,$d` - Delete all lines from below the last line with "modified"
- `-l` - Turn on line exe mode (execute a command on each line)
- `df:dw` - Delete until the ":", then delete the white space
- `xargs git checkout --` - Pass all the filenames to `git checkout --`

## Example 5

Move all Python classes to the bottom of a file:
```
cat myscript.py | vims -e '^class' 'V/^\\S\<enter>kdGp'
```

- `'^class' 'V/^\\S\<enter>kdGp'` becomes `'%g/^class/exe "norm V/^\S\<enter>kdGp"'`
     - `%g/^class/` - Every line starting with "class"
     - `exe` - Execute the following, including escaped sequences (so you can call `\<c-o>` to mean Ctrl-o)
     - `norm V/^\S\<enter>kdGp` Enter normal mode, visual select to the next zero-indentation line, move up a line, delete, paste it at the bottom 
     
## Example 6

Only print the last 6 lines (just like tail)

```
cat txt | vims -n '$-5,$p'
```
- `-n` - Don't print all lines automatically
- `$-5,$` - A range extending from 6th last line to the last line
- `p` - Print

## Example 7

Replace all multi-whitespace sequences with a single space:

```
cat txt | vims '%s/\s\+/ /g'
```

Which can also be done in exe mode:

```
cat txt | vims -e '.' ':s/\\s\\+/ /g\<enter>'
```

Note the double back-slashes needed (only in the second string of a pair in an exe command!)
when you are typing a character like `\s`, but not like `\<enter>`.

## Example 8
Resolve all git conflicts by deleting the changes on HEAD (keep the bottom code):

```
cat my_conflict.cpp | vims -e '^=======$' 'V?^<<<<<<< \<enter>d' -t '%g/^>>>>>>> /d'
```

- `-e` - Turn on exe mode
- `^=======$` - Match the middle bit of a git conflict
- `V?^<<<<<<< \<enter>d` - Highlight the line, backward search to the top of the conflict, delete it.
- `-t` - Turn off exe mode
- `%g/^>>>>>>> /d` - Delete remaining conflict lines


## Example 9

Uncomment all commented-out lines (comment char: `#`)

```
cat script.sh | vims -e '^\s*#' '^x'
```

- `^\s*#` - Work on lines with whitespace followed by a comment char, followed by anything
- `^x` - Go to the first non-whitespace character, and delete it

## Example 10


Delete the first word of each line and put it at the end:

```
cat script.sh | vims -e '^[A-Za-z]' '\"kdwA \<esc>\"kp'
```

- `^[A-Za-z]` - Only work on lines that start with an alphabetical character
- `\"kdw` - Delete the word under the cursor and put it in register `k`
- `A \<esc>` - Start insert mode at front of line, type a space, hit escape key
- `\"kp` - Paste from the register `k`

## Example 11

Run a super-vanilla long chain of commands in simple mode, starting from line 1 of a file:

```
cat python.py | vims -s '/^class\<enter>O# This class broke\<esc>Go\<enter># This file broke'
```

- `/^class\<enter>` - Find the first class, and go to it
- `O# This class broke` - Type above it: "# This class broke"
- `\<esc>Go\<enter>` - Back to normal mode, make two blank lines at end of file
- `# This file broke'` - Write at the end of the file: "# This file broke"


## Example 12

Reverse a file:

```
cat text.txt | vims '%g/.*/m0'
```

- `%g` - Work on all lines that match a pattern
- `.*` - Matches all lines
- `m0` - Move line to start of file

## Example 13

Sort the output of `ls -l` by file size, using the
unix command `sort` (which you can use inside vim):

```
ls -l | vims '1d' '%!sort -k5n'
```

- `1d` - Delete the first line of `ls -l`
- `%!` - Call the following external command on all lines
- `sort` - The unix sort command
- `-k5n` - Sort by column 5, numerically

# Credit

The heart of this script comes from a Google groups posting:
[posting](https://groups.google.com/forum/#!msg/vim_use/NfqbCdUkDb5/Ir0faiNaFZwJ),
and then from an answer on [SO](https://stackoverflow.com/questions/44745046/bash-pass-all-arguments-exactly-as-they-are-to-a-function-and-prepend-a-flag-on)

Thanks!

## TODO

- Find way around vim command limit (only can seem to launch ~8 commands at once to vims - see issue #1)
