{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      eachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in
    {
      lib = eachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          unlayer = pkgs.callPackage ./default.nix { };
        }
      );

      packages = eachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          unlayer-cli = pkgs.callPackage ./unlayer-cli { };
        in
        {
          inherit unlayer-cli;
          default = unlayer-cli;
        }
      );

      checks = eachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          docker = pkgs.callPackage ./tests/test-docker.nix { };
          k3s = pkgs.callPackage ./tests/test-k3s.nix { };
        }
      );
    };
}
