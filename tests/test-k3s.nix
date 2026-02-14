{ dockerTools, testers, k3s, callPackage, ... }:
let
  baseImage = dockerTools.pullImage {
    imageName = "alpine";
    imageDigest = "sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659";
    hash = "sha256-gTKr5yQqJHECyXSyLA9GRT4Qm+ptahnRwy53W8Easb4=";
    finalImageTag = "3.23.3";
  };

  imageStreamer = callPackage ./image.nix { };
  unlayer = callPackage ../. { };

  image = unlayer { inherit imageStreamer baseImage; };
in
testers.runNixOSTest {
  name = "k3s-cowsay-test";

  nodes.machine1 = {
    services.k3s = {
      enable = true;
      role = "server";

      extraFlags = [
        "--disable metrics-server"
        "--disable servicelb"
        "--disable traefik"
      ];

      images = [
        k3s.airgap-images
        image
      ];
    };
  };

  testScript = /*python*/ ''
    start_all()
    with subtest("K3S is running"):
      machine1.wait_for_unit("k3s.service")

    with subtest ("Job runs"):
      job_name = machine1.succeed("kubectl create -f ${./job.yaml} -o name")
      machine1.succeed(f"kubectl wait --for=condition=complete --timeout=60s {job_name}")
  '';
}
