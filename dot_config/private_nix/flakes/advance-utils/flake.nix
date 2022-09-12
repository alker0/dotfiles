{
  description = "Flake for global advance utils";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
  };

  outputs = { self, nixpkgs }@inp:
    let
      l = nixpkgs.lib; # builtins;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: l.genAttrs supportedSystems
        (system: f system (import nixpkgs { inherit system; }));
    in
    {
      defaultPackage = forAllSystems (system: pkgs:
        pkgs.symlinkJoin {
          name = "profile global advance utils";
          paths = with pkgs; [
            curlie
            dog
            # elvish
            fd
            helix
            rm-improved
          ];
        }
      );
    };
}
