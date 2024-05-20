# https://github.com/zmre/mac-nix-simple-example/blob/master/flake.nix
{ pkgs, lib, ... }:
let
  sources = import ./nix/sources.nix;
in
{
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "23.11";
  # specify my home-manager configs
  home.packages = with pkgs; lib.mkBefore [
    curl
    cargo # cargo is depencency of some nvim LSP
    go #  go is depencency of some nvm LSP
    devbox
    direnv
    fd # fd is an unnamed dependency of fzf
    jq
    less
    niv
    magic-wormhole
    ripgrep
    tig
    yq
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    shellAliases = {
      glo = "git log --oneline --decorate";
      ls = "ls --color=auto -F";
      l = "ls -lah";
      ll = "ls -lh";
      nixswitch = "darwin-rebuild switch --flake ~/src/system-config/.#";
      nixup = "pushd ~/src/system-config; nix flake update; nixswitch; popd";
      zssh = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      tolower ="tr '[:upper:]' '[:lower:]'| tr ' ' '-'";
    };
    initExtra = ''
      alias hola1='echo hola1'
      [ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"
    '';

  };

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

# https://nixos.wiki/wiki/Visual_Studio_Code
  programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        # amazonwebservices.aws-toolkit-vscode
        bierner.markdown-mermaid
        bbenoist.nix
        eamodio.gitlens
        # huntertran.auto-markdown-toc
        github.copilot
        github.copilot-chat
        golang.go
        # jinliming2.vscode-go-template
        justusadam.language-haskell
        ms-azuretools.vscode-docker
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-vscode-remote.remote-containers
        # ms-vscode-remote.remote-ssh
        # ms-vscode-remote.remote-ssh-edit
        # ms-vscode-remote.vscode-remote-extensionpack
        ms-vscode.makefile-tools
        # ms-vscode.remote-explorer
        # ms-vscode.remote-server
        oderwat.indent-rainbow
        # redhat.vscode-tekton-pipelines
        redhat.vscode-yaml
        shardulm94.trailing-spaces
        shd101wyy.markdown-preview-enhanced
        #vscjava.vscode-java-pack
        vscodevim.vim
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-java-pack";
          publisher = "vscjava";
          version = "0.25.2023121402";
          sha256 = "2615492b68197b747a769ca7a27fbdc1ab920163dd5b82e61bda115b29427b13";
        }
      ];

      # Default fontFamily: Menlo, Monaco, 'Courier New', monospace
      userSettings = {
          "terminal.integrated.fontFamily" = "'MesloLGSDZ Nerd Font Mono'";
          "editor.fontSize" = 20;
          "editor.fontFamily" = "'MesloLGSDZ Nerd Font Mono', Menlo, Monaco, 'Courier New', monospace";
      };
  };

  # dotfiles:
  home.file = lib.mkBefore {
    ".inputrc".source = ./dotfiles/inputrc;
    ".tigrc".source = ./dotfiles/tigrc;
  };

  xdg.dataFile = {
    "oh-my-zsh".source = sources.oh-my-zsh;
  };

  xdg.configFile = {
    # https://github.com/maxbrunet/dotfiles/blob/main/nix/home.nix
    astronvim = {
      onChange = "PATH=$PATH:${pkgs.git}/bin ${pkgs.neovim}/bin/nvim --headless +quitall";
      source = ./.config/astronvim;
    };

    # https://github.com/maxbrunet/dotfiles/blob/main/nix/home.nix
    nvim = {
      onChange = "PATH=$PATH:${pkgs.git}/bin ${pkgs.neovim}/bin/nvim --headless +quitall";
      source = sources.astronvim;
    };

    # "zsh" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/zsh";
    #   recursive = true;
    # };
  };

}
