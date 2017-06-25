# vim-stream
Use vim as a powerful stream editor, like sed or awk

# Usage

Call `vims` on piped input, providing a list of arguments that you
would use in vim command-line mode.

For example,
to delete every line that matches "foo", and print:

```
cat myfile.txt | vims '%g/foo/d'
```
