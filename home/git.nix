{
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ecdsa.pub";
      signByDefault = true;
    };
    ignores = [
      "*.swp"
      "result"
    ];
    settings = {
      user.name = "Shahar Joselevich";
      user.email = "shahar.joselevich@gmail.com";
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      version = 1;
    };
  };

  home.packages = [ pkgs.git-open ];
}
