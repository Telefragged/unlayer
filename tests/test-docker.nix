{ dockerTools, testers, callPackage, ... }:
let
  baseImage = dockerTools.pullImage {
    imageName = "alpine";
    imageDigest = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659";
    hash = "sha256-gTKr5yQqJHECyXSyLA9GRT4Qm+ptahnRwy53W8Easb4=";
    finalImageTag = "3.23.3";
  };

  unlayer = callPackage ../. { };
  imageStreamer = callPackage ./image.nix { };

  image = unlayer { inherit imageStreamer baseImage; };
in
testers.runNixOSTest {
  name = "docker-cowsay-test";

  nodes.machine1 = {
    virtualisation = {
      docker.enable = true;
    };
  };

  testScript = /*python*/ ''
    start_all()
    machine1.wait_for_unit("docker.service")
    machine1.succeed("docker load < ${image}")
    machine1.succeed("docker run --rm -v /nix/store:/nix/store:ro cowsay:latest")
  '';
}
