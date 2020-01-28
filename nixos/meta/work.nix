{
  hostname = "rogryza-wuzu";
  keymap = "us";
  layout = "us";
  sshKeyGrips = ["8928FD39BEAEC469EDE06393D93637E09DA37593"];
  git = {
    userEmail = "rodrigo@wuzu.io";
    userName = "Rodrigo Gryzinski";
    signing.key = "029F ECFA 4F2D FCE8 7132  9A18 2660 1BD1 67E5 1DEF";
  };
  extraImports = [./hardware-configuration.work.nix];
}
