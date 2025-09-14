
mkdir ~/.cache

# Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
print $'~/.cache/starship/init.nu (ansi green_bold)created(ansi reset)'

# Zoxide
mkdir ~/.cache/zoxide
zoxide init nushell | save -f ~/.cache/zoxide/.zoxide.nu
print $'~/.cache/zoxide/.zoxide.nu (ansi green_bold)created(ansi reset)'

# Atuin
mkdir ~/.cache/atuin
atuin init nu
| str replace -rm '^\$env.config = \((\s.*?\n)*^\s*?keycode: up$(.*?\n)*?^\)$' ''
| str replace 'char_r' 'char_s'
| save -f ~/.cache/atuin/init.nu
print $'~/.cache/atuin/init.nu (ansi green_bold)created(ansi reset)'

# Carapace
mkdir ~/.cache/carapace
carapace _carapace nushell
| save -f ~/.cache/carapace/init.nu
print $'~/.cache/carapace/init.nu (ansi green_bold)created(ansi reset)'

# Mise-en-place
mkdir ~/.cache/mise
mise activate | save -f ~/.cache/mise/activate.nu
print $'~/.cache/mise/activate.nu (ansi green_bold)created(ansi reset)'

