# Unlayer

Unlayer builds docker images produced by `pkgs.dockerTools.streamLayeredImage` _without_ the nix store paths.
This lets the nix store be mounted in through other means to avoid having to pack and unpack large docker images.

This was mostly inspired by the talk [Docker Was Too Slow, So We Replaced It: Nix in Production](https://www.youtube.com/watch?v=iPoL03tFBtU)
, as well as the desire to run k3s tests using several GiB large docker images produced by nix.

## Examples

[k3s](./tests/test-k3s.nix)
[docker](./tests/test-docker.nix)
