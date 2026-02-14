{ dockerTools, cowsay, ... }:
dockerTools.streamLayeredImage {
  name = "cowsay";
  tag = "latest";
  contents = [ cowsay ];
  config = {
    Entrypoint = [ "cowsay" ];
    Cmd = [ "hello world" ];
  };
}
