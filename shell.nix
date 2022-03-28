{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nixpkgs-fmt
    go_1_16
    golangci-lint
  ];

  shellHook = ''
    echo "Welcome to your nix-shell"
  '';
}
