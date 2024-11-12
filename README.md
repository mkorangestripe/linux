# Linux Notes and Examples
![house2](readme_images/house2_cropped.png)

### Linux command examples

Browse the Markdown files in [linux-notes](linux-notes) or use 'git grep' to quickly find examples or which files contain examples.
```shell script
cd linux-notes  # to limit search to the linux-notes directory

git grep -w df  # show examples of the df command

git grep awk    # show examples of the awk command
```

Useful options:
* -B1 : include the previous line, some examples have an explanation above
* -i : ignore case (include **n**etwork and **N**etwork)  
* -n : include line number as show below  
* -w : exclude matches that are part of a word (include **df**, exclude min**df**ul)

![git_grep](readme_images/git_grep.png)

### tldr pages
For more Linux command examples, check out [tldr](https://github.com/tldr-pages/tldr), a collection of simplified man pages.

```shell script
tldr awk
```

### Other commands worth checking out
```shell script
lsd        # ls deluxe, more colors and icons. Also see eza

bat        # cat clone with syntax highlighting and Git integration

fastfetch  # system information, displayed pretty. Also see neofetch

htop       # interactive process viewer
```
