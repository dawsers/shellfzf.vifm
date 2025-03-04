# shellfzf.vifm

[shellfzf.vifm](https://github.com/dawsers/shellfzf.vifm) is a lua plugin for
[vifm](https://github.com/vifm/vifm) that provides a way to run all your
commands expanded with vifm macros from a [fzf](https://github.com/junegunn/fzf)
prompt.

When you run the plugin, you will get a prompt showing all the commands you
have defined in your `shellfzf_commands.txt` file (more below). Select one, and
it will run. You can also run the plugin in interactive mode, so the command
can be edited before it runs.

## Requirements

I have only tested this plugin on Linux.

- Some version of [vifm](https://github.com/vifm/vifm) that supports lua plugins,
probably 0.14 (tested) or newer.
- [fzf](https://github.com/junegunn/fzf) installed in your path.


## Installation

This will install the plugin:

```sh
cd ~/.config/vifm/
mkdir plugins
cd plugins
git clone https://github.com/dawsers/shellfzf.vifm
```

The plugin accepts one argument that can be omitted. If `true` (interactive),
the plugin will let you edit the command before executing it. If omitted or
`false`, the command you select will be executed without user interaction.

Modify your `~/.config/vifmrc` if you want to use some key bindings to run
the plugin:

```vim
" non-interactive"
nnoremap \co :ShellFzf<cr>
" interactive
nnoremap \ci :ShellFzf true<cr>
```


## Shell Commands

Create a `shellfzf_commands.txt` file in your vifm configuration directory with all
the commands you want the plugin to show. Include vifm macros in the commands
so they can be reused.

The format of `shellfzf_commands.txt` is as follows:

* One command per line. The file can contain any number of commands.
* Each command provides, in this order, three fields.
  1. `run`: the command to run
  2. `desc`: a description of the command to make search easier
  3. `block`: `true` or `false`. Whether the command must be run in
     *blocking* mode or not. Blocking means the command will be executed in
     the same terminal vifm is running. Non-blocking spawns the command. To run
     a non-blocking command, the program must have its own UI and not need
     vifm's terminal.

For example:

`/home/dawsers/.config/vifm/shellfzf_commands.txt`

```
run = "kitty", desc = "terminal", block = false
run = "kitty nvim %f", desc = "open in nvim", block = false
run = "nvim %f", desc = "open in nvim", block = true
run = "nvim -d %c %C", desc = "diff files", block = true
run = "nvim -c 'DirDiff %d %D'", desc = "diff dirs", block = true
run = "ouch decompress --dir=%D %f", desc = "decompress with ouch", block = true
run = "ouch compress %f %D/%d:t.tar.gz", desc = "tar.gz compress with ouch", block = true
run = "ouch compress %f %D/%d:t.zip", desc = "zip compress with ouch", block = true
run = "ouch compress %f %D/%d:t.7z", desc = "7z compress with ouch", block = true
run = "zathura %c", desc = "open in zathura", block = false
run = "sioyek %c", desc = "open in sioyek", block = false
```

