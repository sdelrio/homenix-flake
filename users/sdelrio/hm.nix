{ config, pkgs, home-manager, ... }:

{

  programs.git = {
    enable = true;
    userName = "sdelrio";
    userEmail = "sdelrio@users.noreply.github.com";
  };

}
