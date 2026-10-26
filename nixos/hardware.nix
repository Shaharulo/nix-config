{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            settings = {
              allowDiscards = true;
              crypttabExtraOpts = [ "tpm2-device=auto" ];
            };
            # The passphrase is only used during install.
            askPassword = true;
            enrollRecovery = true;
            postCreateHook = ''
              if systemd-cryptenroll "$device" | grep -qw password; then
                systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs= --wipe-slot=password \
                  --unlock-key-file=<(set +x; echo -n "$password"; set -x) "$device"
              fi
            '';
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  hardware.facter.reportPath = lib.mkIf (builtins.pathExists ./facter.json) ./facter.json;

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
      configurationLimit = 4;
      measuredBoot = {
        enable = true;
        # fwupd relaxes PCRs 0 and 2 for BIOS updates. PCR 1 is flaky.
        pcrs = [
          0
          2
          3
          4
          7
        ];
        autoCryptenroll = {
          enable = true;
          inherit (config.boot.initrd.luks.devices.crypted) device;
          autoReboot = true;
        };
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
    zswap.enable = true;
  };

  hardware.enableAllFirmware = true;

  services.fwupd.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
