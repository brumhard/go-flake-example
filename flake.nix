{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    version = "0.0.1";
  in
  rec {
    packages = {
      awesome-thing = pkgs.buildGoModule {
        pname = "awesome-thing";
        version = version;

        vendorSha256 = "sha256-QOeE2K/DydA+xbK3eebeCIzr2LcwNmXlDLs+oNzqmcM=";
        subPackages = [ "cmd/awesome-thing" ];
        src = ./.;

        meta = {
          description = "Awesome Project";
          license = pkgs.lib.licenses.mit;
          maintainers = [ "brumhard" ];
          platforms = pkgs.lib.platforms.linux ++ pkgs.lib.platforms.darwin;
        };
      };
      ociImage = pkgs.dockerTools.buildLayeredImage {
        name = "awesome-image";
        tag = version;
        contents = [self.packages.${system}.awesome-thing];
        config = {
          Cmd = [
            "${self.packages.${system}.awesome-thing}/bin/awesome-thing"
          ];
        };
      };
    };

    # to display `nix flake show .` correctly if `defaultApp` is set
    # see https://github.com/NixOS/nix/pull/5652
    apps.awesome-thing = {
      type = "app";
      program = "${self.packages.${system}.awesome-thing}/bin/awesome-thing";
    };

    defaultPackage = packages.awesome-thing;
    defaultApp = apps.awesome-thing;

    devShell = import ./shell.nix { inherit pkgs; };
  });
}
