{ inputs, ... }:

{
  imports = [ (inputs.srvos.nixosModules.common + "/networking.nix") ];
}
