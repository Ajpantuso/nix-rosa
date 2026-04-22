{
  description = "ROSA CLI - Red Hat OpenShift Service on AWS command-line tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        version = "1.2.61";

        sources = {
          x86_64-linux = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_Linux_x86_64.tar.gz";
            sha256 = "sha256-ufsruNiYkTtc8xHjuw69XCY2YajKqDcIkyCJxPlwGHI=";
          };
          aarch64-linux = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_Linux_arm64.tar.gz";
            sha256 = "sha256-NdAHb6Kw57yilLgE/fira3JV3HBoX+WymUuAdGKb2js=";
          };
          x86_64-darwin = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_Darwin_x86_64.tar.gz";
            sha256 = "sha256-AAy8lY+DpSylf+j3oK6bvci9rMZyvQ6EJkTesdBM8JA=";
          };
          aarch64-darwin = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_Darwin_arm64.tar.gz";
            sha256 = "sha256-M7qwF/WWW/E1pUEdWbGS0tCTNVEIxBt715c42LuMGqk=";
          };
        };

        source = sources.${system} or (throw "Unsupported system: ${system}");

        rosa = pkgs.stdenv.mkDerivation {
          pname = "rosa";
          inherit version;

          src = pkgs.fetchurl {
            inherit (source) url sha256;
          };

          sourceRoot = ".";

          installPhase = ''
            runHook preInstall
            install -D -m755 rosa $out/bin/rosa
            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Red Hat OpenShift Service on AWS (ROSA) command-line interface";
            homepage = "https://github.com/openshift/rosa";
            license = licenses.asl20;
            maintainers = [ ];
            platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
            mainProgram = "rosa";
          };
        };
      in
      {
        packages = {
          default = rosa;
          rosa = rosa;
        };

        apps = {
          default = {
            type = "app";
            program = "${rosa}/bin/rosa";
          };
        };
      }
    );
}
