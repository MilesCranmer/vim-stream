# vims

Do you live in a vim editor? Then, maybe, stream
editing with vim feels more natural than
sed or awk:

```
cat myfile.txt | vims '3,4norm yyGp' '1d'
```
which means: on the 3rd and 4th line, enter normal mode and
copy the line to the bottom of the file. The second command
deletes line 1.


To install,
put `vims` somewhere on your path, e.g., `/usr/bin`.

# Usage

Call `vims` on piped input, providing a list of arguments that you
would use in vim command-line mode. All lines not deleted are printed
by default.

For example,
to delete every line that matches "foo", and print:

```
cat myfile.txt | vims '%g/foo/d'
```

To delete a class called "bar", then all blank lines, then print:

```
cat myscript.py | vims '%g/^class bar/exe "norm V/^\S\<enter>kd"' '%g/^\s*$/d'
```

This finds the line with "class bar" at its start, then
starts visual select mode, goes to the next non-whitespace character
at the front of the line, moves up one line, then deletes.

# Credit

I innovated very little (none) on this script, I basically took a Google Groups
[posting](https://groups.google.com/forum/#!msg/vim_use/NfqbCdUkDb4/Ir0faiNaFZwJ),
then had the nice folks on [SO](https://stackoverflow.com/questions/44745046/bash-pass-all-arguments-exactly-as-they-are-to-a-function-and-prepend-a-flag-on)
help me put it together.

Thanks!
