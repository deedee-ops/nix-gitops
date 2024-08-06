{ pkgs, ... }:
let
  pname = "everdo";
  version = "1.9.0";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://release.everdo.net/${version}/Everdo-${version}.AppImage";
    hash = "sha256-0yxAzM+qmgm4E726QDYS9QwMdp6dUcuvjZzWYEZx7kU=";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
in
pkgs.appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    homepage = "https://everdo.net/";
    description = "A powerful cross-platform GTD app with focus on privacy";
    platforms = [ "x86_64-linux" ];
  };
}
