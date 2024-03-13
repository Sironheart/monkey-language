{
  description = "The implementation of the interpreter/ compiler in go books";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = inputs.nixpkgs.lib.systems.flakeExposed;

        perSystem = { config, self', inputs', pkgs, system, ... }:
          let
            name = "interpreter-go";
            vendorHash = null;
          in
          {
            devShells.default = pkgs.mkShell {
              inputsFrom = [ self'.packages.default ];
            };

            packages = {
              default = pkgs.buildGoModule {
                inherit name vendorHash;
                src = ./.;
              };

              docker = pkgs.dockerTools.buildLayeredImage {
                inherit name;
                tag = "latest";
              };
            };
          };
      };
}
