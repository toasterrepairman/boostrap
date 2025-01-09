final: prev: let
  source = prev.obsidian;

  commandLineArgs = toString [
    "--enable-features=UseOzonePlatform"
    " --ozone-platform=wayland"
    "--enable-zero-copy"
    "--use-gl=desktop"
    "--disable-features=UseOzonePlatform"
    "--enable-features=VaapiVideoDecoder"
  ];

  gpuCommandLineArgs = toString [
    "--enable-accelerated-mjpeg-decode"
    "--enable-accelerated-video"
    "--ignore-gpu-blacklist"
    "--enable-native-gpu-memory-buffers"
    "--enable-gpu-rasterization"
    "--enable-zero-copy"
    "--use-gl=desktop"
    "--disable-features=UseOzonePlatform"
    "--enable-features=VaapiVideoDecoder"
  ];
in {
  obsidian = let
    wrapped = prev.writeShellScriptBin "obsidian" ''
      exec ${source}/bin/obsidian ${commandLineArgs}
    '';

    wrapped' = prev.writeShellScriptBin "Obsidian" ''
      exec ${source}/bin/Obsidian ${commandLineArgs}
    '';
  in
    prev.symlinkJoin {
      name = "obsidian";
      paths = [
        wrapped
        wrapped'
        source
      ];
    };

  obsidian-gpu = let
    wrapped = prev.writeShellScriptBin "obsidian" ''
      exec ${source}/bin/obsidian ${gpuCommandLineArgs}
    '';

    wrapped' = prev.writeShellScriptBin "Obsidian" ''
      exec ${source}/bin/Obsidian ${gpuCommandLineArgs}
    '';
  in
    prev.symlinkJoin {
      name = "obsidian";
      paths = [
        wrapped
        wrapped'
        source
      ];
    };
}
