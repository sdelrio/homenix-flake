{ config, pkgs, home-manager, ... }:

{

  home.packages = with pkgs; lib.mkAfter [
    gh
  ];

#  programs.git = {
#    enable = true;
#    userName = "delrioms";
#    userEmail = "delrioms.sdelrio@users.noreply.github.com";
#  };

}
