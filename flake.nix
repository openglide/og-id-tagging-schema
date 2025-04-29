{
  description = "og-id-tagging-schema project";
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
          env = [];
          commands = [
            {
              help = "Build custom presets and fields";
              name = "build";
              command = "npm run build && npm run dist";
              category = "development";
            }
            {
              help = "Run the servers with cors headers preset, so the local development iD can use this schema for its presets";
              name = "serve";
              command = "npm run build && npm run dist && npx serve --cors";
              category = "development";
            }
          ];
          packages = with pkgs; [
            nodejs
          ];
        };
      };
    };
}
