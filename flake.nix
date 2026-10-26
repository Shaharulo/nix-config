{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mic92-noctalia-plugins = {
      url = "github:Mic92/noctalia-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake.nixosConfigurations.t480s = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./nixos ];
      };

      perSystem =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          checks.formatting = config.formatter.check inputs.self;

          devShells.default = pkgs.mkShellNoCC { packages = [ config.formatter ]; };

          formatter = pkgs.treefmt.withConfig {
            runtimeInputs = with pkgs; [
              nixfmt
              deadnix
            ];
            settings = {
              tree-root-file = "flake.nix";
              on-unmatched = "info";
              formatter = {
                nixfmt = {
                  command = "nixfmt";
                  priority = 3;
                  includes = [ "*.nix" ];
                };
                deadnix = {
                  command = "deadnix";
                  priority = 1;
                  options = [ "--edit" ];
                  includes = [ "*.nix" ];
                };
                # Lower priority runs first. statix only takes one file at a time.
                statix = {
                  priority = 2;
                  command = lib.getExe (
                    pkgs.writeShellApplication {
                      name = "statix-fix";
                      runtimeInputs = [ pkgs.statix ];
                      text = ''for f in "$@"; do statix fix "$f"; done'';
                    }
                  );
                  includes = [ "*.nix" ];
                };
              };
            };
          };
        };
    };
}
