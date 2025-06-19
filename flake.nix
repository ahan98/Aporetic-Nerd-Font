{
  description = "Aporetic Nerd Font";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          fonts = pkgs.stdenv.mkDerivation {
            pname = "aporetic-nerd-font";
            version = "2025-05-31";
            src = self;
            nativeBuildInputs = [ pkgs.fontconfig ];
            dontBuild = true;
            installPhase = ''
              runHook preInstall
              install -d -m 755 $out/share/fonts/truetype
              install -m 644 ./*.ttf $out/share/fonts/truetype/
              runHook postInstall
            '';
            meta.description = "Fonts from Echinoidea/Aporetic-Nerd-Font";
          };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.fonts);
    };
}
