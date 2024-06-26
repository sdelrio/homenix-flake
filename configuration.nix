# configuration in this file is shared by all hosts

{ pkgs, pkgs-unstable, inputs,... }:
let inherit (inputs) self;
in {
  # Enable NetworkManager for wireless networking,
  # You can configure networking with "nmtui" command.
  networking.useDHCP = true;
  networking.networkmanager.enable = false;

  users.users = {
    root = {
      initialPassword = "changeme";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGTsI9Q7a92VGc8QGdTdWxCx1J0W05iYVnkH5Xz4nBm"
      ];
    };
  };

  ## enable GNOME desktop.
  ## You need to configure a normal, non-root user.
  # services.xserver = {
  #  enable = true;
  #  desktopManager.gnome.enable = true;
  #  displayManager.gdm.enable = true;
  # };

  ## enable ZFS auto snapshot on datasets
  ## You need to set the auto snapshot property to "true"
  ## on datasets for this to work, such as
  # zfs set com.sun:auto-snapshot=true rpool/nixos/home
  services.zfs = {
    autoSnapshot = {
      enable = false;
      flags = "-k -p --utc";
      monthly = 48;
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  services.openssh = {
    enable = true;
    settings = { PasswordAuthentication = false; };
  };

  boot.zfs.forceImportRoot = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nix.linux-builder = {
  #   enable = true;
  #
  #   ephemeral = true;
  #   maxJobs = 4;
  #   config = {
  #     virtualisation = {
  #       darwin-builder = {
  #         diskSize = 40 * 1024;
  #         memorySize = 8 * 1024;
  #       };
  #       cores = 6;
  #     };
  #   };
  # };
  #
  # # This line is a prerequisite
  # nix.trusted-users = [ "@admin" ];

  programs.git.enable = true;

  security = {
    doas.enable = true;
    sudo.enable = false;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      #mg # emacs-like editor
      jq # other programs
    ;
  };

  # Safety mechanism: refuse to build unless everything is
  # tracked by git
  #system.configurationRevision = if (self ? rev) then
  #  self.rev
  #else
  #  throw "refuse to build: git tree is dirty";

  system.stateVersion = "23.11";

  # let nix commands follow system nixpkgs revision
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

}
