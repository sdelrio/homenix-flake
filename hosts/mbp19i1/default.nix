# configuration in this file only applies to mbp19i host

{ pkgs, lib, modulesPath, ... }: {

  time.timeZone = lib.mkDefault "Europe/Madrid";

  fonts.fontDir.enable = true; # DANGER only use if all fonts are managed here
  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [
    "Meslo"
  ]; }) ];

  environment.systemPackages = with pkgs; [
    cookiecutter
    coreutils
    magic-wormhole
    neovim
    speedtest-cli
#    syncthing
#    syncthing-tray
#    syncthingtray
    vscode
  ];


  homebrew = {
    casks = [
      "alt-tab"
      "discord"
      "iterm2"
      "onlyoffice"
      "plex-media-player"
      "telegram-desktop"
#      "visual-studio-code"
      "vlc"
    ];
  };


#  programs.iterm2 = { # https://sr.ht/~cfeeley/dotfiles/#homepage
#    enableZshIntegration = true;  # Default: stdenv.isDarwin && config.programs.zsh.enable
#  }

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes repl-flake";

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
      InitialKeyRepeat = 28;
      KeyRepeat = 1;
    };
    screencapture.location = "~/Pictures/screenshos";
  };
}
