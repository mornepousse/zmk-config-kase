{ pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
    config.segger-jlink.acceptLicense = true;
  } }:

let
  pythonEnv = pkgs.python313.withPackages (ps: with ps; [
    west
    pykwalify
    ruamel-yaml
    pyelftools
    pyyaml
    packaging
    intelhex
    cbor2
    cryptography
    protobuf
    grpcio-tools
  ]);
in
pkgs.mkShell {
  buildInputs = [
    pythonEnv
    pkgs.cmake
    pkgs.ninja
    pkgs.dtc
    pkgs.gcc-arm-embedded
    pkgs.nrfutil
    pkgs.protobuf
  ];

  shellHook = ''
    export ZEPHYR_BASE=$PWD/zephyr
    export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
    export GNUARMEMB_TOOLCHAIN_PATH=${pkgs.gcc-arm-embedded}
    export PYTHONPATH=${pythonEnv}/lib/python3.13/site-packages
    echo "KaSe ZMK build environment ready"
    echo "ZEPHYR_BASE=$ZEPHYR_BASE"
  '';
}
