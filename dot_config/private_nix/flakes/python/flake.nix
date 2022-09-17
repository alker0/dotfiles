{
  description = "Flake for global python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:DavHau/mach-nix";
    mach-nix.inputs.nixpkgs.follows = "nixpkgs";
    mach-nix.inputs.flake-utils.follows = "flake-utils";
    #pypi.url = "github:DavHau/pypi-deps-db";
    #pypi.flake = false;
    #mach-nix.inputs.pypi-deps-db.follows = "pypi";
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix, ... }@inp:
    with builtins;
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        l = nixpkgs.lib; # builtins;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # enter this python environment by executing `nix shell .`
        defaultPackage = mach-nix.lib."${system}".mkPython {
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
          ignoreDataOutdated = true;
        };
      }
    );
}
