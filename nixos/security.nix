{
  security.sudo.enable = false;

  security.run0 = {
    enable = true;
    sudo-shim.enable = true;
    persistentAuth.enable = true;
  };

  security.polkit.settings.Polkitd.ExpirationSeconds = 30;

  system.tools.nixos-rebuild.enableRun0Elevation = true;

  security.pam.services.greetd.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;

  security.tpm2.enable = true;
}
