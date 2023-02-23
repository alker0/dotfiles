{
  description = "Flake for profile global";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    advanceUtils.url = "path:./advance-utils";
    advanceUtils.inputs.nixpkgs.follows = "nixpkgs";
    python.url = "path:./python";
    python.inputs.nixpkgs.follows = "nixpkgs";
    python.inputs.flake-utils.follows = "flake-utils";
    #python.inputs.mach-nix.inputs.nixpkgs.follows = "nixpkgs";
    #python.inputs.mach-nix.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inp:
    with builtins;
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        l = nixpkgs.lib;
        pkgs = import nixpkgs { inherit system; };
        subFlakes = l.attrsets.filterAttrs (argName: argValue:
          ! elem argName ["self" "nixpkgs" "flake-utils"]
        ) inp;
        subFlakeDefaultPkgs = l.attrsets.mapAttrs (
          pkgName: pkgValue: pkgValue.defaultPackage."${system}"
        ) subFlakes;
        subFlakeSubPkgs = builtins.zipAttrsWith (name: values: builtins.head values) (
          l.attrsets.mapAttrsToList (subFlakeName: subFlake:
            l.attrsets.mapAttrs' (subPkgName: subPkgValue: {
              name = subFlakeName + ".${subPkgName}";
              value = subPkgValue;
            }) subFlake.packages."${system}"
        ) (l.attrsets.filterAttrs (argName: argValue: argValue ? "packages") subFlakes));
        subFlakePkgs = subFlakeDefaultPkgs // subFlakeSubPkgs;
      in
      rec {
        packages = flake-utils.lib.flattenTree {
          default = pkgs.symlinkJoin {
            name = "profile global";
            paths = with pkgs; [
              bat
              #bitwarden-cli not work
              chezmoi
              curl # maybe need to repair [man bin dev devdoc]
              du-dust
              exa # maybe need to repair [man]
              fzf # maybe need to repair [man]
              gh
              gnupg
              go-task
              pass # password-store ?
              tig
              topgrade
              tree
              unzip
              vim
              zip
              # ---- non required ----
              # deno
              # fnm
              # go
            ];
          };
        } // subFlakePkgs;
        defaultPackage = packages.default;
      }
    );
}
