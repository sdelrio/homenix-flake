{
  description = "Barebones NixOs with Linux ZFS, Darwin options";

  inputs = {
    # Where we get most of our software. Giant monorepo with recipes
    # called derivations where say how to build software
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";

    # Control system level software and settings including font
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Manages configs links into your home directory
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management. See https://github.com/EmergentMind/nix-config/blob/dev/docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self,
              nixpkgs,
              nixpkgs-unstable,
              nix-darwin,
              home-manager,
              sops-nix,
              ... } @inputs:
    let
      mkHost = hostName: system:
        nixpkgs.lib.nixosSystem {
          pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

        specialArgs = {
          # By default, the system will only use packages from the
          # stable channel.  You can selectively install packages
          # from the unstable channel.  You can also add more
          # channels to pin package version.
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            # settings to nixpkgs-unstable goes to here
          };

          # make all inputs availabe in other nix files
          inherit inputs;
	      };
	    
        modules = [
          # Module 0: zfs-root
          ./modules

          # Module 1: host-specific config, if exist
          #(if (builtins.pathExists ./hosts/${hostName}/configuration.nix) then
          #  ./hosts/${hostName}/configuration.nix 
          #else
          #  { })

          # Module 2: entry point

          # Module 4: config shared by all hosts
          ./configuration.nix

          # configuration input
          ./hosts/${hostName}

          # Module 3: home-manager
          #home-manager.nixosModules.home-manager
          #{
          #  home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;
          #  #home-manager.users.sdelrio = import ./home.nix;
          #}
        ];
          };

      mkMac = hostName: system: myUser:
        nix-darwin.lib.darwinSystem {
          pkgs = import nixpkgs {
            inherit system; # Makes system = system (x86_64-darwin or aarch64-darwin)
            config = { allowUnfree = true; };
          };

          specialArgs = {
            # By default, the system will only use packages from the
            # stable channel.  You can selectively install packages
            # from the unstable channel.  You can also add more
            # channels to pin package version.
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              # settings to nixpkgs-unstable goes to here
            };

            # make all inputs availabe in other nix files
            inherit inputs;
          };

          modules = [
            # Generic Darwin module configuration for all hosts
	          ./modules/darwin
            # configuration input
            #inputs.sops-nix.nixosModules.sops
            #./hosts/common/core/sops.nix
            # Host configuration modules
            ./hosts/${hostName}

            # Module home-manager

            # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565974702
            ({ users.users.${myUser}.home = "/Users/${myUser}"; })

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${myUser}.imports = [
                  inputs.sops-nix.homeManagerModules.sops
                  ./modules/home-manager
                  ./hosts/${hostName}/hm.nix
                  ./users/${myUser}/hm.nix
                ];
              };
            }
          ];
        };
    in {
      nixosConfigurations = {
        exampleHost = mkHost "exampleHost" "x86_64-linux";
        nexus = mkHost "nexus" "x86_64-linux";
        vm1-gnome = mkHost "vm1-gnome" "x86_64-linux";
        vm1-cinnamon = mkHost "vm1-cinnamon" "x86_64-linux";
        vm1-terminal = mkHost "vm1-terminal" "x86_64-linux";
      };
      darwinConfigurations = {
  	    mbp19i1 = mkMac "mbp19i1" "x86_64-darwin" "sdelrio";
        delrioms-KVNV5T = mkMac "delrioms-KVNV5T" "aarch64-darwin" "delrioms";
      };
    };
}
