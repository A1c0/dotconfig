
mkdir ~/.cache

# Proto
mkdir ~/.cache/proto
proto completions --shell nu | save -f ~/.cache/proto/completions.nu

# Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# Zoxide
mkdir ~/.cache/zoxide
zoxide init nushell | save -f ~/.cache/zoxide/.zoxide.nu

# Atuin
mkdir ~/.cache/atuin
atuin init nu
| str replace -rm '^\$env.config = \((\s.*?\n)*^\s*?keycode: up$(.*?\n)*?^\)$' ''
| str replace 'char_r' 'char_s'
| save -f ~/.cache/atuin/init.nu


# Carapace
mkdir ~/.cache/carapace
carapace _carapace nushell
| save -f ~/.cache/carapace/init.nu

