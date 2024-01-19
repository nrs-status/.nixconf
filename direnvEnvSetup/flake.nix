{

  description = "Setup dir env .envrc to use flake";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    systems = {
      url = "./../systems.nix";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, systems }:
    nixpkgs.lib.genAttrs (import systems) (system:
      let
        pkgs = import nixpkgs {inherit system;};
      in
      {
        packages.${system}.default = self.packages.${system}.dirEnvSetup;

        packages.${system}.dirEnvSetup =
          let
            scriptName = "dirEnvSetup";
            script = pkgs.writeShellScriptBin "dirEnvSetup"
              ''echo "use flake" > .envrc
              direnv allow
              direnv reload'';
          in pkgs.symlinkJoin {
          name = scriptName;
          paths = [ script nixpkgs.legacyPackages.${system}.direnv ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${scriptName} --prefix PATH : $out/bin";
      };
      }
    );

}
