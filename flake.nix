{
  description = "Go project flake template";
  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      imports = [
        inputs.devshell.flakeModule
      ];
      perSystem = {
        self,
        pkgs,
        config,
        lib,
        system,
        ...
      }: {
        devshells.default = {
          env = [
            # this is a hack, using 'eval', to install pre-commit hooks, since devshell doesn't have shellHook to hook into
            # We don't actually need an env var named PRE_COMMIT
            # {
            #   name = "PRE_COMMIT";
            #   eval = "${config.pre-commit.installationScript}";
            # }
          ];
          commands = [
            {
              help = "Build custom presets and fields";
              name = "build";
              command = "npm run dist";
              category = "development";
            }
          ];
          packages = with pkgs; [
            go_1_24
          ];
        };
      };
    };
}
