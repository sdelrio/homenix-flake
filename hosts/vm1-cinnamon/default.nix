# configuration in this file only applies to exampleHost host
#
# only zfs-root.* options can be defined in this file.
#
# all others goes to `configuration.nix` under the same directory as
# this file.

{ config, pkgs, lib, inputs, modulesPath, ... }: {

  programs.tmux = {
    enable = true;
    newSession = true;
    terminal = "tmux-direct";
  };
  services.emacs.enable = false;
  i18n.defaultLocale = "es_ES.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };
  services.xserver = {
    enable = true;
    desktopManager.cinnamon.enable = true;
    displayManager.lightdm.enable = true;
    layout = "es";
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  console = pkgs.lib.mkForce {
    keyMap = "es";
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  zfs-root = {
    boot = {
      devNodes = "/dev/disk/by-id/";
      bootDevices = [ "virtio-abcdef0123456789" ];

      immutable = false;
      removableEfi = true;
    };
  };

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.kernelParams = [ "nohibernate" "mitigations=off" ];

  networking = {
    # read changeHostName.txt file.
    hostName = "vm1-cinnamon";
    hostId = "53bb851e";
  };
  time.timeZone = "Europe/Madrid";

  # import preconfigured profiles
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # (modulesPath + "/profiles/hardened.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../users/sdelrio/user.nix
    ../../users/sdelrio/fonts.nix
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  users.users.sdelrio.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    bitwarden
    brave
    corectrl
    firefox
    ## Keyboard-driven layer for GNOME Shell
    # gnomeExtensions.pop-shell
    gpa
    lutris
    # onlyoffice
    plex-media-player
    syncthing
    syncthing-tray
    solaar
    telegram-desktop
    # steam
    # virt-manager
    vscode
    zsh
    hwloc
  ];

  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    #TERMINAL = "kitty";
  };

}
