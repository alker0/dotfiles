{
  description = "Flake for profile global";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    advanceUtils.url = "path:./advance-utils";
    python.url = "path:./python";
  };

  outputs = { self, nixpkgs, ... }@inp:
    with builtins;
    let
      l = nixpkgs.lib;
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      defaultPackage.x86_64-linux = pkgs.symlinkJoin {
        name = "profile global";
        paths = with pkgs; [
          bat
          bitwarden-cli
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
      packages = foldl' (prev: pkgName:
        let
          flakeResult = inp."${pkgName}".defaultPackage;
        in
          foldl' (prevDerivs: system:
            let
            in l.recursiveUpdate prevDerivs
            {
              "${system}"."${pkgName}" = flakeResult."${system}";
            }
          ) prev (attrNames flakeResult)
      ) {} (attrNames (l.attrsets.filterAttrs (argName: argValue:
          ! elem argName ["self" "nixpkgs"]
        ) inp));
    };
}
