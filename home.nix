{ config, pkgs, ... }:

{
  home.username = "sburba";
  home.homeDirectory = "/home/sburba";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    unzip

    # utils
    jq # A lightweight and flexible command-line JSON processor
    wl-clipboard # cli copy/past

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor


    # Monitoring
    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # Development
    gh

    # GUIs
    icon-library
  ];

  programs.git = {
    enable = true;
    userName = "Sam Burba";
    userEmail = "github@samburba.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    extraConfig = ''
      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initContent = ''
      export PATH="$PATH:$HOME/.local/bin"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "vi-mode" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      sudo = "sudo ";
      nixup = "sudo nixos-rebuild switch";
      nixtest = "sudo nixos-rebuild test";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.caffeine.extensionUuid
          pkgs.gnomeExtensions.pop-shell.extensionUuid
          pkgs.gnomeExtensions.weather-oclock.extensionUuid
        ];
      };
      "org/home/mutter" = {
        edge-tiling = false;
      };
      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
      };
      "org/gnome/desktop/wm/keybindings" = {
        # Overlaps with pop-shell's keybindings
        minimize = [];
      };
      "org/gnome/shell/keybindings" = {
        # Overlaps with pop-shell's keybindings
        toggle-quick-settings = [];
      };
      "org/gnome/desktop/datetime" = {
        automatic-timezone = true;
      };
      "org/gnome/desktop/interface" = {
        clock-format = "12h";
      };
      "org/gtk/settings/file-chooser" = {
        clock-format = "12h";
      };
      "org/gnome/Console" = {
        theme = "auto";
      };
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["caps:swapescape"];
      };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
