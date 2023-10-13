# configuration in this file only applies to exampleHost host
#
# only zfs-root.* options can be defined in this file.
#
# all others goes to `configuration.nix` under the same directory as
# this file.

{ pkgs, inputs, ...}:
let inherit (inputs) nixpkgs;
in {
  zfs-root = {
    boot = {
      devNodes = "/dev/disk/by-id/";
      bootDevices = [ "virtio-abcdef0123456789" ];
      immutable = false;
      removableEfi = true;
      sshUnlock = {
        # read sshUnlock.txt file.
        enable = false;
        authorizedKeys = [ ];
      };
    };
  };

  boot = {
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
    kernelParams = [ "nohibernate" "mitigations=off" ];
  };

  networking = {
    hostName = "vm1-terminal";
    hostId = "53bb851e";
  };

  time.timeZone = "Europe/Madrid";

  # imports preconfigured profiles
  imports = [
    "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
    # "${nixpkgs}/nixos/modules/profiles/hardened.nix"
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    #"./users/sdelrio/user.nix"
  ];

  users.users.sdelrio = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups =
      [ "wheel" "networkmanager" "audio" "docker" "nixconfig" "dialout" ];
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGTsI9Q7a92VGc8QGdTdWxCx1J0W05iYVnkH5Xz4nBm"
      ];
    };
    packages = with pkgs; [
      tree
    ];
  };
}
