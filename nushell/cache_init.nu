
mkdir ~/.cache

def fix_with_hash [hash: string, fix: closure]: string -> string {
  let input: string = $in;
  let input_hash: string = $input | str replace --regex --all \s '' | hash md5
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
starship init nu | save --force ~/.cache/starship/init.nu
print $'~/.cache/starship/init.nu (ansi green_bold)created(ansi reset)'

# Zoxide
mkdir ~/.cache/zoxide
zoxide init nushell | save --force ~/.cache/zoxide/.zoxide.nu
print $'~/.cache/zoxide/.zoxide.nu (ansi green_bold)created(ansi reset)'

# Atuin
mkdir ~/.cache/atuin
atuin init nu
| str replace --regex --multiline '^\$env.config = \((\s.*?\n)*^\s*?keycode: up$(.*?\n)*?^\)$' ''
| str replace 'char_r' 'char_s'
| save --force ~/.cache/atuin/init.nu
print $'~/.cache/atuin/init.nu (ansi green_bold)created(ansi reset)'

# Mise-en-place
mkdir ~/.cache/mise
mise activate --shell nu
| save --force ~/.cache/mise/activate.nu
print $'~/.cache/mise/activate.nu (ansi green_bold)created(ansi reset)'

# Mise-en-place
mkdir ~/.cache/pueue
pueue completions nushell | save --force ~/.cache/pueue/completions.nu
print $'~/.cache/pueue/completions.nu (ansi green_bold)created(ansi reset)'

