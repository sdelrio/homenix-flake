{ config, pkgs, ...}: {

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    brews = [
      "cask"
    ];

    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask"
    ];
  };

}
