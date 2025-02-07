# config.nu
#
# Installed by:
# version = "0.102.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config.show_banner = false

# Note: The conversions happen *after* config.nu is loaded
let bool_conversion = { from_string: { |s| $s | into bool } to_string: { |v| $v | into string } }
$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | insert __zoxide_hooked $bool_conversion

source ~/.cache/zoxide/.zoxide.nu;
source ~/.cache/carapace/init.nu;
source ~/.cache/proto/completions.nu;

alias meteo = curl v2.wttr.in

# PUPPETEER Chromium fail on M1 chip
$env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true

alias clr = clear
alias la = ls -la
alias gm = pnpm dlx gitmoji-cli -c
alias lg = lazygit

use ./nu_scripts/custom-completions/zellij/zellij-completions.nu *
use ./nu_scripts/custom-completions/git/git-completions.nu *
use ./nu_scripts/custom-completions/glow/glow-completions.nu *

# Theme
source ./nu_scripts/themes/nu-themes/catppuccin-macchiato.nu
$env.BAT_THEME = "Catppuccin Macchiato"
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$env.LS_COLORS = (vivid generate catppuccin-macchiato | str trim)
$env.FZF_DEFAULT_OPTS = " --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 --color=selected-bg:#494d64 --multi";

source .my-nu-scripts/_all.nu

# Nu Shells feature
use std/dirs shells-aliases *

# Prompt
use ~/.cache/starship/init.nu

$env.__ORIG_PATH = $env.PATH;

# Add node_module/.bin & proto_hook
$env.config = ($env | default {} config).config
$env.config = ($env.config | default {} hooks)
$env.config = ($env.config | update hooks ($env.config.hooks | default {} env_change))
$env.config = ($env.config | update hooks.env_change ($env.config.hooks.env_change | default [] PWD))
$env.config = ($env.config | update hooks.env_change.PWD ($env.config.hooks.env_change.PWD | append {|before, after| 
    let config = proto activate --json | from json;

    let node_bin_path = $after | path join node_modules .bin; 
    let is_node_path = $node_bin_path | path exists;

    if $is_node_path {
        $env.PATH = $env.__ORIG_PATH | prepend $node_bin_path | prepend $config.paths
    } else {
        $env.PATH = $env.__ORIG_PATH | prepend $config.paths
    }
}))

# Utils
def toxic-slack [] {input | str downcase | split chars | each {$":alphabet-white-($in):"} | str join '' | str replace --all ":alphabet-white- :" "   " | str replace --all ":alphabet-white-!:" ":alphabet-white-exclamation:" | pbcopy}

# Spawn new Node.js projet 
def new-node-projet [] {
    {name: (pwd | path basename), version: "0.0.0" licence: "MIT"} | save package.json
}

def pinggy [port: int] {
    ssh -p 443 $"-R0:localhost:($port)" a.pinggy.io
}

def open-dot-env [file:string] {open $file | lines --skip-empty | filter {$in =~ '^\s*[^#]'} | parse -r '(?<key>[^=#]+)=\"?(?<value>.*?)\"?$' | transpose -rd}

alias za = zellij attach;
def update_file [file: string, closure: closure] {open $file | do $closure $in | save -f $file};

module alacritty-config {
    export def opacity [ratio: float] {update_file ~/.config/alacritty/alacritty.toml { update window.opacity $ratio }}
    export def blur [blur: bool] {update_file ~/.config/alacritty/alacritty.toml { update window.blur $blur }}
}
use alacritty-config;

# List of installed brew formulae and casks as a nu table
def "brew state" [] {
    let brew_formula = brew list --installed-on-request -1 | lines; 
    brew info --json=v2 --installed 
    | from json 
    | update formulae {
        where name in $brew_formula 
        | select name full_name tap versions 
        | rename --block {str camel-case}} 
    | update casks {
        select token full_token tap name version 
        | rename --block {str camel-case}}
}

def --env yy [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

def "dock hide delay" [second: int] {
    defaults write com.apple.dock autohide-delay -float $second
    killall Dock
}

def restart_superkey [] {
  ps | where name like '(?i)superkey' | first | kill $in.pid;
  ^open /Applications/Superkey.app
}
