{ pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    tree
    htop
  ];

  time.timeZone = "Asia/Jerusalem";
}
