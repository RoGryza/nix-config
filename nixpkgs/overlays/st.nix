self: super:
{
  st = super.st.override {
    patches = [
      "${super.fetchurl {
        url = "https://st.suckless.org/patches/xresources/st-xresources-20190105-3be4cf1.diff";
        sha256 = "112zi7jqzj6601gp54nr4b7si99g29lz61c44rgcpgpfddwmpibi";
      }}"
    ];
  };
}
