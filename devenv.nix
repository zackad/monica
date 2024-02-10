{ pkgs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    nodejs-slim
    yarn
  ];

  # https://devenv.sh/scripts/
  scripts.hello.exec = "echo hello from $GREET";

  enterShell = ''
    hello
  '';

  # https://devenv.sh/languages/
  languages.php = {
    enable = true;
    package = pkgs.php82.buildEnv {
      extensions = { all, enabled}: with all; enabled ++ [ redis pcov ];
    };
  };

  services.mysql = {
    enable = true;
    ensureUsers = [
      {
        name = "devenv";
        ensurePermissions = {
          "monica.*" = "ALL PRIVILEGES";
        };
      }
    ];
    initialDatabases = [
      { name = "monica"; }
    ];
  };

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  processes.assets.exec = "yarn run watch";
  processes.web.exec = "php artisan serve";

  # See full reference at https://devenv.sh/reference/options/
}
