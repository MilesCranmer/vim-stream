# vim-stream
Use vim as a powerful stream editor, like sed or awk

# Usage

Call `vims` on piped input, providing a list of arguments that you
would use in vim command-line mode.

For example,
to delete every line that matches "foo", and print:

```
cat myfile.txt | vims -c ':%g/foo/d'
```

To delete a class called "bar", then all blank lines, then print:

```
cat myscript.py | vims -c ':%g/^class bar/exe "norm V/^\S\<enter>kd"' -c ':%g/^\s*$/d'
```

This finds the line with "class bar" at its start, then
starts visual select mode, goes to the next non-whitespace character
at the front of the line, moves up one line, then deletes.
