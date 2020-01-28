{
  hostname = "rogryza-wuzu";
  hashedPassword = "$6$c/obJGjdZ0$Uv9ned1qruxx1mHSBj.tqijqlizJSrUKuIzy/a4aHxz2ZKTVukGJpntm/89la1quSsfl2dyKGu6dRyD495dkK.";
  keymap = "us";
  xkb = {
    layout = "us,us";
    variant = ",intl";
  };
  sshKeyGrips = ["8928FD39BEAEC469EDE06393D93637E09DA37593"];
  git = {
    userEmail = "rodrigo@wuzu.io";
    userName = "Rodrigo Gryzinski";
    signing.key = "029F ECFA 4F2D FCE8 7132  9A18 2660 1BD1 67E5 1DEF";
  };
  extraImports = [./hardware-configuration.work.nix];
  networkInterfaces = ["enp3s0"];
}
