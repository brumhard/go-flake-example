{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/31ffc50c";
    flake-utils.url = "github:numtide/flake-utils/7e5bf3925";
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

        modSha256 = lib.fakeSha256;
        vendorSha256 = null;

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
