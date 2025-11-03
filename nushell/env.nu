# Nushell Environment Config File

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
    '/opt/homebrew/bin' # Homebrew in directory
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

$env.EDITOR = 'hx'

$env.PATH = ($env.PATH | prepend [
 "/opt/homebrew/bin",
 "/opt/homebrew/sbin",
 "/usr/local/bin",
 "~/.local/bin",
 "~/.cargo/bin",
 "~/go/bin",
])


# Homebrew
$env.HOMEBREW_NO_AUTO_UPDATE = 1;

# Set the shell to the current shell. Needed for topgrade or zellij
$env.SHELL = (^which nu)

$env.VIRTUAL_ENV_DISABLE_PROMPT = 1

# Transient Prompt
$env.TRANSIENT_PROMPT_COMMAND = ^starship module character
$env.TRANSIENT_PROMPT_INDICATOR = ""
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ""
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ""
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = ""
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ^starship module time

# Overlay in starship
$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append {||
    $env.NU_ACTIVE_OVERLAYS = (overlay list | where active and name != zero | get name | str join ',')
})

$env.config.table.missing_value_symbol = $"(ansi grey)∅(ansi reset)"

$env.PAGER = 'less -RS'
