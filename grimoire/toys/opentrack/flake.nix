{
  description = "Opentrack with ONNX support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Define aruco as a local dependency
        aruco = pkgs.callPackage ./aruco.nix { };

        opentrackWithOnnx = pkgs.opentrack.overrideAttrs (oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [ pkgs.onnxruntime ];

          cmakeFlags = oldAttrs.cmakeFlags ++ [
            "-DONNXRuntime_DIR=${pkgs.onnxruntime}/lib/cmake/onnxruntime"
            "-DONNXRuntime_INCLUDE_DIR=${pkgs.onnxruntime}/include/onnxruntime"
          ];
        });
      in
      {
        packages = {
          default = opentrackWithOnnx;
          opentrack = opentrackWithOnnx;
        };

        apps = {
          default = {
            type = "app";
            program = "${opentrackWithOnnx}/bin/opentrack";
          };
        };
      }
    );
}
