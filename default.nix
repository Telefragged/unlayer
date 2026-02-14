{ stdenvNoCC, callPackage, ... }:
let
  unlayer-cli = callPackage ./unlayer-cli { };
in
{ baseImage, imageStreamer }:
stdenvNoCC.mkDerivation {
  name = "${imageStreamer.name}.tar";

  buildInputs = [ unlayer-cli ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = "unlayer -c ${imageStreamer.conf} -o ./image.tar ${baseImage}";
  installPhase = "mv ./image.tar $out";
}
