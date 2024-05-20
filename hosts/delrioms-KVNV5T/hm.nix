{ config, lib, ... }: {
  # https://github.com/Cu3PO42/gleaming-glacier/blob/5abb8c0a3fb72cafbc7ca113e5f135142d0b51c8/features/home-manager/darwin/iterm2.nix
  #copper.file.home."Library/Preferences/com.googlecode.iterm2.plist" = "config/iterm2.plist";

  home.file = lib.mkAfter {
    "Library/Preferences/com.googlecode.iterm2.plist".source = ../../programs/iterm2_arm.plist;
  };
}
