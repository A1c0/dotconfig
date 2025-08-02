
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
let md5_atuin = "96354ab81f8318e2fb78d4fd1dcd1532"
if (atuin init nu | hash md5 | $in != $md5_atuin) {
  error make {msg: "altui init script change"}
}

mkdir ~/.cache/atuin
atuin init nu
| str replace -rm '^\$env.config = \((\s.*?\n)*^\s*?keycode: up$(.*?\n)*?^\)$' ''
| str replace 'char_r' 'char_s'
| str replace -a 'get -i' 'get -o'
| save -f ~/.cache/atuin/init.nu


# Carapace
mkdir ~/.cache/carapace
carapace _carapace nushell
| save -f ~/.cache/carapace/init.nu

