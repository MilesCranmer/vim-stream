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

Or, using [the power of `:g`](http://vim.wikia.com/wiki/Power_of_g),
```
cat myscript.py | vims '%g/^class/exe "norm V/^\S\<enter>kdGp"'
```
which moves all classes to the bottom of the file:
 - `%g/^class/` - Every line starting with "class"
 - `exe "norm V/^\S\<enter>kdGp"` Enter normal mode, visual select to the next zero-indentation line, move up a line, delete, paste it at the bottom



# Usage

To install,
put `vims` somewhere on your path, e.g., `/usr/bin`. It's pretty much
a one-liner convenient version of pre-built vim commands.

Call `vims` on piped input, providing a list of arguments that you
would use in vim command-line mode. All lines not deleted are printed
by default, but you can turn this off with a `-n|--silent|--quiet` flag.

For example,
to delete every line that matches "foo", and print:

```
cat myfile.txt | vims '%g/foo/d'
```

# Credit

I innovated very little (none) on this script, I basically took a Google Groups
[posting](https://groups.google.com/forum/#!msg/vim_use/NfqbCdUkDb4/Ir0faiNaFZwJ),
then had the nice folks on [SO](https://stackoverflow.com/questions/44745046/bash-pass-all-arguments-exactly-as-they-are-to-a-function-and-prepend-a-flag-on)
help me put it together.

Thanks!
