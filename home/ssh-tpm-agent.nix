{
  pkgs,
  config,
  ...
}:
{
  services.ssh-tpm-agent = {
    enable = true;
    package = pkgs.ssh-tpm-agent.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "Foxboron";
        repo = "ssh-tpm-agent";
        rev = "5d1974b94bfb5bdc1cde68bb1aa38580a42c6fe1"; # For --confirm-loaded, unreleased.
        hash = "sha256-4PAo/r++DIQ7ZZgBoffXH99MzDJfpWr/uyvFwsIINek=";
      };
      # nixpkgs' test patches are for 0.9.0 and break on master.
      preCheck = "";
    };
    extraArgs = [ "--confirm-loaded" ];
  };

  systemd.user.services.ssh-tpm-agent.Service.Environment = [
    "SSH_ASKPASS=${config.home.sessionVariables.SSH_ASKPASS}"
    "SSH_ASKPASS_REQUIRE=force"
  ];
}
