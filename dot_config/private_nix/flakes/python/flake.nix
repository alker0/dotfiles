{
  description = "Flake for global python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    mach-nix.url = "mach-nix/3.4.0";
  };

  outputs = { self, nixpkgs, mach-nix }@inp:
    let
      l = nixpkgs.lib; # builtins;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: l.genAttrs supportedSystems
        (system: f system (import nixpkgs { inherit system; }));
    in
    {
      # enter this python environment by executing `nix shell .`
      defaultPackage = forAllSystems (system: pkgs:
        mach-nix.lib."${system}".mkPython {
          python = "python310";
          requirements = ''
            numpy
            requests
            pip
            black
            pyflakes
            poetry # for isort
            isort
            pyright
          '';
        }
      );
    };
}
