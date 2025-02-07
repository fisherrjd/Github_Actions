{ pkgs ? import
    (fetchTarball {
      name = "jpetrucciani-2025-02-07";
      url = "https://github.com/jpetrucciani/nix/archive/94c912d800e2a52b1fa040fcfecd96afca826d09.tar.gz";
      sha256 = "0my36bzr0pzjfyj70asf59wl9n2cvxc2mw99jpx7a5gqb9y1q55j";
    })
    { }
}:
let
  name = "Github_Actions";


  tools = with pkgs; {
    cli = [
      jfmt
      nixup
    ];
    python = [
      ruff
      (python311.withPackages (p: with p; [
        black
        pytest
      ]))
    ];
    scripts = pkgs.lib.attrsets.attrValues scripts;
  };

  scripts = with pkgs; { };
  paths = pkgs.lib.flatten [ (builtins.attrValues tools) ];
  env = pkgs.buildEnv {
    inherit name paths; buildInputs = paths;
  };
in
(env.overrideAttrs (_: {
  inherit name;
  NIXUP = "0.0.8";
})) // { inherit scripts; }
