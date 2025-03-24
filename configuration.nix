{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  programs.neovim.enable = true;
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  services.k3s = {
    enable = true;
    role = "server"; # or "agent" for worker nodes
    extraFlags = "--disable traefik"; # Optional, disable built-in Traefik
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.k3s
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILcnpXSCxOeJRIhAQEZuqui5vyV6EmkN/s8R7V3breZH"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGcwGR1zrxyFGZawej/u7/TI2m1Cvi+Lc6eFnlb1efV"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsbuI9rlQlPXGnu+QFj217kj0+XqTQQyTX6WFn2UXYU"
  ];

  networking.firewall.allowedTCPPorts = [ 6443 ];

  system.stateVersion = "24.05";
}
