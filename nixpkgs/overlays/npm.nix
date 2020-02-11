self: super:
{
  nodePackages =
    (super.nodePackages or {}) //
    super.callPackage ../modules/wflow {};
}
