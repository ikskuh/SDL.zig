{
  description = "A Nix-flake-based Zig development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          zig
          zls
          zig-shell-completions
          SDL2
          SDL2.dev
          SDL2_gfx
          SDL2_ttf
          SDL2_image
          pkg-config
          libjpeg
          libjpeg.dev
          libtiff
          libpng
        ];
      };
    });
  };
}
