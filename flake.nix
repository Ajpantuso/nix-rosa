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
        version = "1.2.65";

        sources = {
          x86_64-linux = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_linux_amd64.zip";
            sha256 = "sha256-ADy1x9IfrUqXpvvh0RTsMlCvsnZNMzmlAG2CMOt0Se4=";
          };
          aarch64-linux = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_linux_arm64.zip";
            sha256 = "sha256-Ek7r+DXE8SqQIzRgHB2aRui6PwUSrtyvP1BVOkgLrpA=";
          };
          x86_64-darwin = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_darwin_amd64.zip";
            sha256 = "sha256-1qy3eFauxaBAtMeMMlIzjrefKnh7k8WSN3nADKsvrnk=";
          };
          aarch64-darwin = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_darwin_arm64.zip";
            sha256 = "sha256-RG7wq4mvextAMht9ZcFVO0Ld53xHETp93ph/vKa9ZGY=";
          };
        };

        source = sources.${system} or (throw "Unsupported system: ${system}");

        rosa = pkgs.stdenv.mkDerivation {
          pname = "rosa";
          inherit version;

          src = pkgs.fetchurl {
            inherit (source) url sha256;
          };

          nativeBuildInputs = [ pkgs.unzip ];

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
