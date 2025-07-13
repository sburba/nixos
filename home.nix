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
  ];

  programs.git = {
    enable = true;
    userName = "Sam Burba";
    userEmail = "github@samburba.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
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
      vim = "nvim";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.caffeine.extensionUuid
	  pkgs.gnomeExtensions.pop-shell.extensionUuid
	];
      };
      "org/home/mutter" = {
        edge-tiling = false;
      };
      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
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
