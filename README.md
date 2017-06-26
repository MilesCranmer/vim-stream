# vims

Do you live in a vim editor? Then, maybe, stream
editing with vim feels more natural than
sed or awk:

```
cat myfile.txt | vims '3,4norm yyGp' '1d'
```
which means: 
 - `3,4norm yyGp` on the 3rd and 4th line, enter normal mode and
copy the line to the bottom of the file.
 - `1d` delete line 1


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
{command} | vims [-n|--silent] [-d|--disable-vimrc] [-e|--exe-mode]
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

## Example 1
To delete every line that matches "foo", and print:

```
cat myfile.txt | vims '%g/foo/d'
```

Your default vimrc should be enabled by default, turn it off with
`-d|--disable-vimrc`.

## Example 2
Delete blank lines, then lower-case everything:

```
cat mylog.log | vims -e '^\s*$' 'dd' '.' 'Vu'
```

- `^\s*$` - Line only containing whitespace
- `dd` - Delete it.
- `.` - Line containing anything (Every pair of arguments triggers a new `exe` command)
- `Vu` - Select the line, then lower-case all alphabetical characters

## Example 3

Say you want to move all Python classes to the bottom of a file:
```
cat myscript.py | vims -e '^class' 'V/^\S\<enter>kdGp'
```
which uses "exe" mode to move all classes to the bottom of the file:
 - `'^class' 'V/^\S\<enter>kdGp'` becomes `'%g/^class/exe "norm V/^\S\<enter>kdGp"'`
     - `%g/^class/` - Every line starting with "class"
     - `exe` - Execute the following, including escaped sequences (so you can call `\<c-o>` to mean Ctrl-o)
     - `norm V/^\S\<enter>kdGp` Enter normal mode, visual select to the next zero-indentation line, move up a line, delete, paste it at the bottom 
     
## Example 4

Only print the last 4 lines (just like tail)

```
cat txt | vims -n '$-4,$p'
```
- `$-4,$` - A range extending from 4th last line to the last line
- `p` - Print

## Example 5

Replace all multi-whitespace sequences with a single space:

```
cat txt | vims '%s/\s\+/ /g'
```

## Example 6

Uncomment all commented-out lines (comment char: `#`)

```
cat script.sh | vims -e '^\s*#' '^x'
```

# Credit

I innovated very little (none) on this script, I basically took a Google Groups
[posting](https://groups.google.com/forum/#!msg/vim_use/NfqbCdUkDb4/Ir0faiNaFZwJ),
then had the nice folks on [SO](https://stackoverflow.com/questions/44745046/bash-pass-all-arguments-exactly-as-they-are-to-a-function-and-prepend-a-flag-on)
help me put it together.

Thanks!
