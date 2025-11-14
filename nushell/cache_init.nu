
mkdir ~/.cache

def fix_with_hash [hash: string, fix: closure]: string -> string {
  let input: string = $in;
  let input_hash: string = $input | str replace -r -a \s '' | hash md5
  if $input_hash == $hash {
    do $fix $input
  } else {
    print --stderr "The hash doesn't match"
    print $"expected : ($hash)"
    print $"evaluated: ($input_hash)"
    exit 1
  }
}

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

# # Carapace
# mkdir ~/.cache/carapace
# carapace _carapace nushell
# | save -f ~/.cache/carapace/init.nu
# print $'~/.cache/carapace/init.nu (ansi green_bold)created(ansi reset)'

# Mise-en-place
mkdir ~/.cache/mise
mise activate
  | fix_with_hash "46e6cc44298931df1d21ca515c313422" {|source|
    $source
    | lines
    | skip 7
    | str join (char newline)
  }
  | save -f ~/.cache/mise/activate.nu
print $'~/.cache/mise/activate.nu (ansi green_bold)created(ansi reset)'

# Mise-en-place
mkdir ~/.cache/pueue
pueue completions nushell | save -f ~/.cache/pueue/completions.nu
print $'~/.cache/pueue/completions.nu (ansi green_bold)created(ansi reset)'

