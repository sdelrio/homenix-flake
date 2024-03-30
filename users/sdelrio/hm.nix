{ config, pkgs, home-manager, ... }:

{

  home.packages = with pkgs; lib.mkAfter [
    gh
  ];

  programs.git = {
    enable = true;
    userName = "sdelrio";
    userEmail = "sdelrio@users.noreply.github.com";
  };

}
