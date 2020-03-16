self: super:
{
  dwm = super.dwm.overrideAttrs(oa: {
    patches = oa.patches ++ map super.fetchurl [
      {
        url = "https://dwm.suckless.org/patches/noborder/dwm-noborder-6.2.diff";
        sha256 = "1q7g4ig120my7xlbybasf7jmsqd8g70z0cc79fp26bas7sb5zgwv";
      }
      {
        url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.2.diff";
        sha256 = "19m7s7wfqvw09z9zb3q9480n42xcsqjrxpkvqmmrw1z96d2nn3nn";
      }
      {
        url = "https://dwm.suckless.org/patches/nodmenu/dwm-nodmenu-6.2.diff";
        sha256 = "1z6b89aa2l9kpm1vydmm058l46w4xdafm5yfkjasa55m4kkb6xhp";
      }
    ];
  });
}
