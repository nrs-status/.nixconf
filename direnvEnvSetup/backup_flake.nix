{

  description = "Setup dir env .envrc to use flake";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {system = system;};
    in
      {
        packages.${system}.default =
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

      };
}
