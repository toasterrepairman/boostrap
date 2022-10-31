{
  packageOverrides = pkgs: rec {
    obsidian = pkgs.obsidian.overrideDerivation (attrs: {
      configureFlags = [
        "--enable-features=UseOzonePlatform" 
        "--ozone-platform=wayland"
      ];
      doCheck = "";
    });
  };
}
