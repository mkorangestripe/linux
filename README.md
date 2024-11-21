# Little Linux Library

![house2](readme_images/house2_cropped.png)

### Linux Notes and Examples

Browse topics in [linux-notes](linux-notes) or clone this repo and use 'git grep' to quickly find examples in multiple contexts.
```shell script
cd linux/linux-notes

git grep awk    # show examples of the awk command
git grep -w df  # show examples of the df command
```

Useful options:
* -B1 : include the previous line, some examples have an explanation above
* -i : ignore case (include **n**etwork and **N**etwork)  
* -n : include line number  
* -w : exclude matches that are part of a word (include **df**, exclude min**df**ul)

The -m option shown here is only used to limit results.

![git_grep](readme_images/git_grep.jpg)

### tldr pages

For more Linux command examples, check out [tldr](https://github.com/tldr-pages/tldr), a collection of simplified man pages.

```shell script
tldr awk  # show examples of the awk command
```

### Other new commands worth checking out

```shell script
lsd        # ls deluxe, more colors and icons, similar to eza

bat        # cat with syntax highlighting and Git integration

fastfetch  # system information, displayed pretty, similar to neofetch

htop       # interactive process viewer
```

### Other Topics

The linux-notes directory also has notes and examples on the following:
* [Ansible](linux-notes/ansible.md)
* [Docker](linux-notes/docker.md)
* [Git](linux-notes/git.md)
* [Python versions, virtual envs, & packages](linux-notes/python-management.md)
* [Vagrant](linux-notes/vagrant.md)

### Package Updates

To schedule package updates on a laptop or desktop, see [package-updates](package-updates)
