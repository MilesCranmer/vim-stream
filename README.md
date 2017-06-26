# vims

Do you live in a vim editor? Then, maybe, stream
editing with vim feels more natural than
sed or awk:

```
cat myfile.txt | vims '3,4norm yyGp' '%g/foo/d'
```
which means: 
 - `3,4norm yyGp` - on the 3rd and 4th line, enter normal mode and
copy the line to the bottom of the file.
 - `%g/foo/d` - delete every line containing "`foo`"


You can also use "exe" mode (flag `-e`):
for example, to comment out in C++
every line containing `my_bad_var`,
then delete the line above it:

```
cat my_script.cpp | vims -e 'my_bad_var' 'I//\<esc>kdd'
```

Which translates to `vims '%g/my_bad_var/exe "norm I//\<esc>kdd"'` - the `I` being the command
to start insert at the start of the line, and `//` being the comment sequence.
`\<esc>kdd` pushes the escape key, moves up a line, then deletes the line.

# Usage/Examples

To install,
put `vims` somewhere on your path, e.g., `/usr/bin`.

```
{command} | vims [-n|--silent] [-d|--disable-vimrc]
                 [-e|--exe-mode] [-r|--inverse-exe-mode]
                 [ <args>... ]
```

Call `vims` on piped input, providing a list of arguments that you
would use in vim command-line mode. All lines not deleted are printed
by default, but you can turn this off with a `-n|--silent` flag.

Trigger "exe" mode using the `-e|--exe-mode` flag, which creates macros
for `'%g/$1/exe "norm $2"'` (see [the power of `:g`](http://vim.wikia.com/wiki/Power_of_g)),
where `$1` is the first arg of a pair,
and `$2` is the last arg of a pair. This lets you type non-text characters,
like `\<esc>`, `\<c-o>`, etc.

Inverse exe mode is done with the `-r|--inverse-exe-mode` flag, which
does the same as exe mode, but only on lines NOT matching the regex.

Your default vimrc should be enabled by default, turn it off with
`-d|--disable-vimrc`.

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

## Example 3

Add a comment (`#`) on every line NOT containing foo:

```
cat script.sh | vims -r 'foo' 'A # Comment'
```

- `-r` - Work on all lines not matching regex
- `foo` - Match all lines with the word "foo"
- `A # Comment` - At the end of the line, type " # Comment"

## Example 4

Say you want to move all Python classes to the bottom of a file:
```
cat myscript.py | vims -e '^class' 'V/^\S\<enter>kdGp'
```

- `'^class' 'V/^\S\<enter>kdGp'` becomes `'%g/^class/exe "norm V/^\S\<enter>kdGp"'`
     - `%g/^class/` - Every line starting with "class"
     - `exe` - Execute the following, including escaped sequences (so you can call `\<c-o>` to mean Ctrl-o)
     - `norm V/^\S\<enter>kdGp` Enter normal mode, visual select to the next zero-indentation line, move up a line, delete, paste it at the bottom 
     
## Example 5

Only print the last 5 lines (just like tail)

```
cat txt | vims -n '$-5,$p'
```
- `-n` - Don't print all lines automatically
- `$-5,$` - A range extending from 5th last line to the last line
- `p` - Print

## Example 6

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

## Example 7

Uncomment all commented-out lines (comment char: `#`)

```
cat script.sh | vims -e '^\s*#' '^x'
```

- `^\s*#` - Work on lines with whitespace followed by a comment char, followed by anything
- `^x` - Go to the first non-whitespace character, and delete it

## Example 8


Delete the first word of each line and put it at the end:

```
cat script.sh | vims -e '^[A-Za-z]' '\"kdwA \<esc>\"kp'
```

- `^[A-Za-z]` - Only work on lines that start with an alphabetical character
- `\"kdw` - Delete the word under the cursor and put it in register `k`
- `A \<esc>` - Start insert mode at front of line, type a space, hit escape key
- `\"kp` - Paste from the register `k`

# Credit

I innovated very little (none) on this script, I basically took a Google Groups
[posting](https://groups.google.com/forum/#!msg/vim_use/NfqbCdUkDb5/Ir0faiNaFZwJ),
then had the nice folks on [SO](https://stackoverflow.com/questions/44745047/bash-pass-all-arguments-exactly-as-they-are-to-a-function-and-prepend-a-flag-on)
help me put it together.

Thanks!
