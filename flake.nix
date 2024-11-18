{
  description = "DBMS";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default =
        pkgs.mkShell { buildInputs = with pkgs; [ sqlite ]; };
    };
}
