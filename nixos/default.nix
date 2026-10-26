{
  inputs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    "${modulesPath}/profiles/perlless.nix"
    inputs.home-manager.nixosModules.default
    ./hardware.nix
    ./hyprland.nix
    ./laptop.nix
    ./misc.nix
    ./networking.nix
    ./nix.nix
    ./printing.nix
    ./security.nix
    ./users.nix
  ];

  # Keep the rest of the perlless profile, but don't fail the build on perl.
  system.forbiddenDependenciesRegexes = lib.mkForce [ ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users.shahar = import ../home;
  };

  networking.hostName = "t480s";

  system.stateVersion = "26.11";
}
