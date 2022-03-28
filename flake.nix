{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  rec {
    packages = flake-utils.lib.flattenTree {
      awesome-thing =
      let
        lib = pkgs.lib;
      in
      pkgs.buildGoModule {
        pname = "awesome-thing";
        version = "0.0.1";

        vendorSha256 = "sha256-QOeE2K/DydA+xbK3eebeCIzr2LcwNmXlDLs+oNzqmcM=";
        subPackages = [ "cmd/awesome-thing" ];
        src = ./.;

        meta = {
          description = "Awesome Project";
          license = lib.licenses.mit;
          maintainers = [ "brumhard" ];
          platforms = lib.platforms.linux ++ lib.platforms.darwin;
        };
      };
    };

    defaultPackage = packages.awesome-thing;
    defaultApp = packages.awesome-thing;

    devShell = import ./shell.nix { inherit pkgs; };
  }
  );
}
