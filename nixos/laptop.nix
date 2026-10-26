{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.brightnessctl ];

  # VA-API for the Intel UHD 620.
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General = {
      ControllerMode = "dual";
      Experimental = true;
    };
  };

  services.tuned = {
    enable = true;
    ppdSettings = {
      main.default = "power-saver";
      battery = {
        inherit (config.services.tuned.ppdSettings.profiles) power-saver;
      };
    };
  };
}
