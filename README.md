# nix-config

NixOS and home-manager flake for a ThinkPad T480s, flattened from
[Kranzes/nix-config](https://github.com/Kranzes/nix-config).

- disko: LUKS2 with ext4. The TPM unlocks it, with a recovery key as the only
  fallback.
- lanzaboote: Secure Boot and a `systemd-pcrlock` measured boot policy, both set
  up automatically.
- nixos-facter instead of `hardware-configuration.nix`.
- Hyprland, noctalia v5 and noctalia-greeter, themed Catppuccin Macchiato.

## Install

### 1. Firmware (F1 at boot)

- Update the BIOS. Thunderbolt firmware 1.50 or newer avoids the T480s
  Thunderbolt bug.
- Enable TPM 2.0 in *Security → Security Chip*.
- In *Security → Secure Boot*, choose *Reset to Setup Mode* and *Clear All
  Secure Boot Keys*. Leave Secure Boot enabled.
- Boot the NixOS unstable installer. If it won't boot in Setup Mode, disable
  Secure Boot and turn it back on before the first boot after step 3. Until
  Secure Boot is on, the temporary TPM slot unlocks the disk for any OS.

### 2. Partition

```console
$ git clone https://github.com/shaharulo/nix-config && cd nix-config
$ sudo nix --extra-experimental-features 'nix-command flakes' \
    run nixpkgs#nixos-facter -- -o nixos/facter.json
$ git add nixos/facter.json
$ sudo $(nix --extra-experimental-features 'nix-command flakes' build --no-link --print-out-paths \
    .#nixosConfigurations.t480s.config.system.build.destroyFormatMount)/bin/disko-destroy-format-mount
```

disko asks for a throwaway passphrase, then prints the recovery key. Save it.
It's the only way in if the TPM refuses. disko then adds a temporary TPM slot
for the first boots and wipes the passphrase.

To remount after an installer reboot:

```console
$ sudo cryptsetup open /dev/disk/by-partlabel/disk-main-luks crypted   # recovery key
$ sudo mount /dev/mapper/crypted /mnt
$ sudo mount /dev/disk/by-partlabel/disk-main-ESP /mnt/boot
```

### 3. Install

```console
$ sudo nixos-install --flake .#t480s --no-root-passwd
$ sudo nixos-enter --root /mnt -c 'passwd shahar'
$ sudo cp -r . /mnt/home/shahar/nix-config && sudo nixos-enter --root /mnt -c 'chown -R shahar:users /home/shahar/nix-config'
$ reboot
```

The laptop reboots twice on its own. The first boot creates and stages the
Secure Boot keys. The second enrolls them and seals the disk to the TPM policy
(PCRs 0, 2, 3, 4 and 7). Then check:

```console
$ bootctl status | grep 'Secure Boot'   # enabled (user)
$ systemd-cryptenroll /dev/disk/by-partlabel/disk-main-luks   # tpm2 + recovery
```

Create the SSH key, which also signs git commits, then commit
`nixos/facter.json`:

```console
$ ssh-tpm-keygen
```

## BIOS updates

Use `fwupdmgr update`. fwupd relaxes the TPM policy for the update, so the disk
still unlocks. Flashing any other way asks for the recovery key once.
