{
  description = "bgs scraper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      pythonEnv = pkgs.python3.withPackages (
        ps: with ps; [
          requests
        ]
      );
    in
    {
      packages.${system}.default = pkgs.writeShellApplication {
        name = "bgs";
        runtimeInputs = [ pkgs.git ];
        text = ''
          cd "$(git rev-parse --show-toplevel)"
          exec ${pythonEnv}/bin/python ${./src/bgs.py} "$@"
        '';
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pythonEnv
        ]
        ++ (with pkgs; [
          black
          pyright
        ]);
        shellHook = ''
          export PS1="\n\[\033[1;32m\][nix-shell:\w]\$\[\033[0m\] "
        '';
      };
    };
}
