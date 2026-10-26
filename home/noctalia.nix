{
  inputs,
  config,
  lib,
  ...
}:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        # noctalia downloads this palette from api.noctalia.dev on first start.
        source = "community";
        community_palette =
          let
            inherit (config.catppuccin) flavor accent;
          in
          "Catppuccin ${lib.toSentenceCase flavor} ${lib.toSentenceCase accent}";
      };
      plugins = {
        enabled = [ "mic92/ssh-askpass" ];
        source = [
          {
            name = "mic92";
            kind = "path";
            location = "${inputs.mic92-noctalia-plugins}";
          }
        ];
      };
    };
  };
}
