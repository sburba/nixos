# Modified version of
# https://forrestjacobs.com/keeping-nixos-systems-up-to-date-with-github-actions/
{ config, lib, pkgs, ... }: {
  systemd.services.pull-updates = {
    description = "Pulls changes to system config";
    restartIfChanged = false;
    onSuccess = [ "rebuild.service" ];
    startAt = "04:40";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [pkgs.git pkgs.openssh];
    script = ''
      test "$(git branch --show-current)" = "main"
      git pull --ff-only
    '';
    serviceConfig = {
      WorkingDirectory = "/etc/nixos";
      User = "sburba";
      Type = "oneshot";
    };
  };

  # This requires the following command to be run first:
  # sudo git config --global --add safe.directory <nix repo location>
  # NixOS won't manage home directories, and home-manager won't
  # manage root directories, so for now this has to be done manually
  systemd.services.rebuild = {
    description = "Rebuilds and activates system config";
    restartIfChanged = false;
    path = [pkgs.nixos-rebuild pkgs.systemd];
    startAt = "daily";
    script = ''
      nixos-rebuild switch
    '';
    serviceConfig = {
      WorkingDirectory = "/etc/nixos";
      User = "root";
      Type = "oneshot";
    };
  };
}
