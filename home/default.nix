{
  inputs,
  lib,
  ...
}:

{
  home = {
    stateVersion = "26.11";
    enableNixpkgsReleaseCheck = false;
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = lib.mkDefault "macchiato";
    accent = lib.mkDefault "lavender";
  };

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./packages.nix
    ./programs.nix
    ./fonts.nix
    ./services.nix
    ./editors.nix
    ./terminal.nix
    ./ssh.nix
    ./ssh-tpm-agent.nix
    ./git.nix
    ./hyprland.nix
    ./noctalia.nix
    ./fuzzel.nix
    ./shell.nix
    ./gtk-qt.nix
    ./devel.nix
    ./browser.nix
    ./slop.nix
  ];
}
