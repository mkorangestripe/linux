### Find examples

Browse the Markdown files here or use 'git grep' to quickly find examples, finds examples in multiple contexts, or find which files contain the command examples.
```shell script
git grep -w df  # show examples of the df command

git grep awk    # show examples of the awk command
```

Useful options:
* -B1 : include the previous line, some examples have the explanation there  
* -i : ignore case (Aa, Bb, Cc)  
* -n : include line number as show below  
* -w : exclude matches that are part of a word (include **df** not min**df**ul)

![git_grep](../readme_images/git_grep.png)

### tldr pages
For more examples, check out [tldr](https://github.com/tldr-pages/tldr) a collection of simplified and community-driven man pages.

```shell script
tldr awk
```

### Other commands worth checking out
```shell script
lsd        # ls deluxe, more colors and icons

bat        # cat clone with syntax highlighting and Git integration

neofetch   # system information, displayed pretty

fastfetch  # system information, displayed pretty

htop       # interactive process viewer
```
