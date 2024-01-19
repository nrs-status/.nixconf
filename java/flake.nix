# File 'flake.nix'.
# obtained from https://dschrempf.github.io/emacs/2023-03-02-emacs-java-and-nix/
{
  description = "Java development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    direnvScript =
  }
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages.default = dirEnvSetup;

        devShells.default = with pkgs; mkShell {
          packages = [
            # Gradle, Java development kit, and Java language server.
            gradle
            jdk
            jdt-language-server
          ];
          # Environment variable specifying the plugin directory of
          # the language server 'jdtls'.
          JDTLS_PATH = "${jdt-language-server}/share/java";
        };
      }
    );
}
