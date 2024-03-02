# https://github.com/zmre/mac-nix-simple-example/blob/master/flake.nix
{ pkgs, ... }:
let
  sources = import ./nix/sources.nix;
in
{
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";
  # specify my home-manager configs
  home.packages = with pkgs; [
    curl
    fd # fd is an unnamed dependency of fzf
    less
    niv
    ripgrep
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nvim";
  };
  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.eza.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.syntaxHighlighting.enable = true;

  programs.zsh.shellAliases = {
    glo = "git log --oneline --decorate";
    ls = "ls --color=auto -F";
    l = "ls -lah";
    ll = "ls -lh";
    nixswitch = "darwin-rebuild switch --flake ~/src/system-config/.#";
    nixup = "pushd ~/src/system-config; nix flake update; nixswitch; popd";
    zssh = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
  };
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  # dotfiles:
  home.file = {
    ".inputrc".source = ./dotfiles/inputrc;
    ".tigrc".source = ./dotfiles/tigrc;
  };

#  xdg.dataFile = {
#    "oh-my-zsh".source = sources.oh-my-zsh;
#  };

  xdg.configFile = {
    astronvim = { # https://github.com/maxbrunet/dotfiles/blob/main/nix/home.nix
      onChange = "PATH=$PATH:${pkgs.git}/bin ${pkgs.neovim}/bin/nvim --headless +quitall";
      source = ./.config/astronvim;
    };
    nvim = {
      onChange = "PATH=$PATH:${pkgs.git}/bin ${pkgs.neovim}/bin/nvim --headless +quitall";
      source = sources.astronvim;
    };
  };
}
