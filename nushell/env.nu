# Nushell Environment Config File
#
# version = "0.89.0"

def create_left_prompt [] {
    let home =  $nu.home-path

    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X %p') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

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
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
$env.PATH = ($env.PATH | split row (char esep)
  | prepend '~/.bun/bin'
  | prepend '~/.config/composer/vendor/bin'
  | prepend '~/.asdf/installs/golang/1.22.2/packages/bin')

# asdf
# $env.ASDF_DIR = (brew --prefix asdf | str trim | into string | path join 'libexec')
# source /opt/homebrew/opt/asdf/libexec/asdf.nu
$env.ASDF_DIR = $"($env.HOME)/.nix-profile/share/asdf-vm"
source ~/.nix-profile/share/asdf-vm/asdf.nu

# LS_COLORS
$env.LS_COLORS = (vivid generate catppuccin-macchiato | str trim)

# Wordpress ENVs
$env.WORDPRESS_DEBUG = 1
$env.WORDPRESS_DB_HOST = localhost:3306
$env.WORDPRESS_CONFIG_EXTRA = "define( 'SCRIPT_DEBUG', true );"
$env.WORDPRESS_DB_PASSWORD = wordpress
$env.WORDPRESS_DB_USER = wordpress
$env.WORDPRESS_DB_NAME = wordpress

# Aliases
alias tauri = cargo-tauri
alias cat = bat
alias grep = batgrep
alias rgrep = batgrep --context=0
alias man = batman
alias du = dust
alias gitui = gitui -t ~/.config/gitui/themes/catppuccin-macchiato.ron
alias l = eza --icons
alias ls = eza --icons
alias f = joshuto
alias e = hx-zellij.sh
alias jt = bash -c 'jira issue list -abrunov@lifebit.ai --order-by "status ASC,priority" -sBacklog -sBlocked -s"To Do" -s"In Progress" -s"In Review" -s"In PR"'
alias groot = cd (git rev-parse --show-toplevel)
alias npm = bun
alias node = bun

# Def
def stream [command] {
    if $command == 'start' {
       ^open $"($env.HOME)/Applications/Stream Avatars.app"
       ^open $"($env.HOME)/Applications/keeb-overlay.app"
       ^open /Applications/KeyCastr.app
       ^open /Applications/EyeSpy.app
       ^open /System/Applications/Music.app
       sleep 10sec
       ^open /Applications/OBS.app
    } else if $command == 'stop' {
        for app in [
            "keeb-overlay" "KeyCastr" "EyeSpy" "Music" "Steam" "OBS"
        ] {
            osascript -e $"quit app \"($app)\"" | ignore
        }
    }
}

# Yazi file manager shell wrapper to change cwd when exit
def --env yy [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}
