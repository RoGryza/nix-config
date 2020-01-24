{
  hostname = "rogryza";
  keymap = "br-abnt2";
  layout = "br";
  sshKeyGrips = ["8D9342B7F994DE2B879A03F4CF270B470301BE9C"];
  git = {
    userEmail = "rogryza@gmail.com";
    userName = "Rodrigo Gryzinski";
    signing.key = "7FD1 6300 B3BF 7FF3 2C90  C904 0E64 06D3 1049 F61D";
  };
  extraImports = [./hardware-configuration.home.nix];
}
