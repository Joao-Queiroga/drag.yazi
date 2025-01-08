# drag.yazi

A Yazi plugin to drag and drop files using [ripdrag](https://github.com/nik012003/ripdrag)

## Install

```sh
# For Unix platforms
git clone https://github.com/Joao-Queiroga/drag.yazi.git ~/.config/yazi/plugins/ripdrag.yazi

## For Windows
git clone https://github.com/Joao-Queiroga/drag.yazi.git %AppData%\yazi\config\plugins\ripdrag.yazi

# Or with yazi plugin manager
ya pack -a Joao-Queiroga/drag
```

- Add this to your `keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = [ "<C-d>" ]
run  = "plugin drag"
desc = "Drag Files"
```

## Credits

- [archivemount.yazi](https://github.com/AnirudhG07/archivemount.yazi): The place where I shamelessly stole some functions
