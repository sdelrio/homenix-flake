# configuration in this file only applies to mbp19i host
{ config, inputs, pkgs, pkgs-unstable, lib, modulesPath, ... }:
let
  stablePackages = with pkgs; [
    cookiecutter
    coreutils
    dive
    gnupg
    gawk
    htop
    kubectl
    kubelogin-oidc
    kubectl-cnpg
    kubernetes-helm
    kustomize
    fluxcd
    magic-wormhole
    sops
    teller
    tmux
    tmuxPlugins.resurrect
    trivy
    neovim
    qemu
    speedtest-cli
    vscode
    zenith
  ];
  unstablePackages = with pkgs-unstable; [
    k9s
    kubeswitch
    minikube
  ];
in {

  time.timeZone = lib.mkDefault "Europe/Madrid";

  fonts.fontDir.enable = true; # DANGER only use if all fonts are managed here
  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [
    "Meslo"
  ]; }) ];

  environment.systemPackages = stablePackages ++ unstablePackages;

  # https://github.com/LnL7/nix-darwin/blob/master/modules/homebrew.nix
  homebrew = {
    casks = [
      "alt-tab"
      "docker"
      "iterm2"
      "lm-studio"
      "keepassxc"
      "onlyoffice"
      "telegram-desktop"
      "vlc"
    ];
#    global.options = {
#      upgrade = true;
#      autoUpdate = true;
#    };
  };


#  programs.iterm2 = { # https://sr.ht/~cfeeley/dotfiles/#homepage
#    enableZshIntegration = true;  # Default: stdenv.isDarwin && config.programs.zsh.enable
#  }

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes repl-flake";

  #https://evanrelf.com/building-x86-64-packages-with-nix-on-apple-silicon/
  nix.extraOptions = ''
  extra-platforms = x86_64-darwin aarch64-darwin
'';

  # https://nixcademy.com/2024/01/15/nix-on-macos/
  # https://nixcademy.com/2024/02/12/macos-linux-builder/
  nix.settings.extra-trusted-users = [ "@admin" ];

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    # (the defaults are 1 CPU core, 3GB RAM, and 20GB disk
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };

  # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
  system.activationScripts.postUserActivation.text = ''
    # Following line should allo us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = pkgs.system;  #  (x86_64-darwin or aarm64-darwin)

  environment.variables = {
    EDITOR = "nvim";
  };

  # Unlocking sudo via fingerprint
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/dock.nix
    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "left";
      tilesize = 16; # Default is 64
      magnification = true;
      largesize = 128;
    };
    trackpad = {
      TrackpadRightClick = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      _FXShowPosixPathInTitle = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 28;
      KeyRepeat = 1;
    };
    screencapture.location = "~/Pictures/screenshots";
  };
}
