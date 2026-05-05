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
        version = "1.2.62";

        sources = {
          x86_64-linux = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_Linux_x86_64.tar.gz";
            sha256 = "sha256-wCLvZAmLR+jrKA7Iu0RK0ZLW4F/QZjROSKJrz0Z+k/g=";
          };
          aarch64-linux = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_Linux_arm64.tar.gz";
            sha256 = "sha256-B4DMVusHISmbohIjdGteolFjkMt63WWmjwHaIpXLYP8=";
          };
          x86_64-darwin = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_Darwin_x86_64.tar.gz";
            sha256 = "sha256-XmBvESwU0hyU9UsAJHc/nXMlowrXxfDe27vw4ORzcrA=";
          };
          aarch64-darwin = {
            url = "https://github.com/openshift/rosa/releases/download/v${version}/rosa_Darwin_arm64.tar.gz";
            sha256 = "sha256-tT9IOsg4Xe1LEmYlZJt9+C8R/rLES+N/3KuqAYUjLFI=";
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
