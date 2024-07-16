{ inputs, ... }:

let
  useNixGL = false;
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  nixGLpkgs = inputs.nixGL.packages.x86_64-linux;
in
pkg:
if useNixGL then
  (pkg.overrideAttrs (old: {
    name = "nixGL-${pkg.name}";
    buildCommand = ''
      set -eo pipefail

      ${
      pkgs.lib.concatStringsSep "\n" (map (outputName: ''
        echo "Copying output: ${outputName}"
        set -x
        cp -rs --no-preserve=mode "${pkg.${outputName}}" "''$${outputName}"
        set +x
      '') (old.outputs or [ "out" ]))}

      rm -rf $out/bin/*
      shopt -s nullglob
      for file in ${pkg.out}/bin/*; do
        export LIBVA_DRIVER_NAME="nvidia"
        export LIBVA_DRIVERS_PATH="${pkgs.nvidia-vaapi-driver}/lib/dri/"
        echo "#!${pkgs.bash}/bin/bash" > "$out/bin/$(basename $file)"
        echo "exec -a \"\$0\" ${nixGLpkgs.nixGLDefault}/bin/nixGL $file \"\$@\"" >> "$out/bin/$(basename $file)"
        chmod +x "$out/bin/$(basename $file)"
      done
      shopt -u nullglob
    '';
  }))
else
  (pkg.overrideAttrs (old: { }))
