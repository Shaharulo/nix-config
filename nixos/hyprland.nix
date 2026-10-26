{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    # noctalia syncs its theme to the greeter without a password prompt.
    passwordlessSyncUsers = [ "shahar" ];
  };

  security.pam.services.hyprlock = { };
}
