{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dash";
  home.homeDirectory = "/Users/dash";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    htop
    # Shell
    bottom
    vivid
    eza
    bat
    bat-extras.prettybat
    bat-extras.batwatch
    bat-extras.batpipe
    bat-extras.batman
    bat-extras.batgrep
    bat-extras.batdiff
    broot
    choose
    du-dust
    yazi
    # Git
    gh
    gitui
    # Dev
    asdf-vm
    # JavaScript
    nodejs
    bun
    yarn
    ripgrep
    jq
    fd
    sd
    vivid
    tree-sitter
    tre-command
    tldr
    k9s
    jellyfin-ffmpeg
    fzf
    # Go
    gotools
    gopls
    # Rust
    rustc
    rustup
    cargo-tauri
    trunk
    # Other
    yt-dlp
    asdf
    taskwarrior
    w3m
    lynx
    links2
    # AI
    # ollama
    # Desktop apps
    gimp
    inkscape
    # Languages server for helix
    vscode-langservers-extracted
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    dockerfile-language-server-nodejs
    nodePackages.vscode-html-languageserver-bin
    lua-language-server
    marksman
    nil
    nodePackages.vscode-json-languageserver
    python311Packages.python-lsp-server
    R
    nodePackages.vscode-css-languageserver-bin
    nodePackages.svelte-language-server
    yaml-language-server
    phpactor
    php83Packages.composer
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/gitui/themes/catppuccin-macchiato.ron".text = ''
    (
        selected_tab: Some("Reset"),
        command_fg: Some("#cad3f5"),
        selection_bg: Some("#5b6078"),
        selection_fg: Some("#cad3f5"),
        cmdbar_bg: Some("#1e2030"),
        cmdbar_extra_lines_bg: Some("#1e2030"),
        disabled_fg: Some("#8087a2"),
        diff_line_add: Some("#a6da95"),
        diff_line_delete: Some("#ed8796"),
        diff_file_added: Some("#a6da95"),
        diff_file_removed: Some("#ee99a0"),
        diff_file_moved: Some("#c6a0f6"),
        diff_file_modified: Some("#f5a97f"),
        commit_hash: Some("#b7bdf8"),
        commit_time: Some("#b8c0e0"),
        commit_author: Some("#7dc4e4"),
        danger_fg: Some("#ed8796"),
        push_gauge_bg: Some("#8aadf4"),
        push_gauge_fg: Some("#24273a"),
        tag_fg: Some("#f4dbd6"),
        branch_fg: Some("#8bd5ca")
    )
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dash/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_macchiato"; 
      editor = {
        line-number = "relative";
        rulers = [120];
      };
    };
  }; 
  programs.nushell = {
    enable = true;
    configFile.source = ./nushell/config.nu;
    envFile.source = ./nushell/env.nu;
  };
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      command_timeout = 1000;
    };
  };
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "nu";
      theme = "catppuccin-macchiato";
    };
  };
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      -- Pull in the wezterm API
      local wezterm = require 'wezterm'

      -- This table will hold  the configuration.
      local config = {}

      -- In newer versions of wezterm, use the config_builder which will
      -- help provide clearer error messages
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- This is where you actually apply your config choices
      config.color_scheme = 'Catppuccin Macchiato'
      config.hide_tab_bar_if_only_one_tab = true
      config.window_background_opacity = 0.95
      config.macos_window_background_blur = 20
      config.window_decorations = "RESIZE"
      config.default_prog = { 'zsh', '-i', '-c', 'nu' }

      -- and finally, return the configuration to wezterm
      return config
    '';
  };
  programs.zsh = {
    enable = true;
    initExtra = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      alias tauri="cargo-tauri"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
  programs.zk = {
    enable = true;
    # More settings: https://github.com/zk-org/zk/blob/main/docs/config.md
    settings = {
      notebook = {
        dir = "~/notes";
      };
    };
  };
}
