{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Hyprland and Wayland tools
    xwayland
    wl-clipboard
    grim
    slurp
    swappy
    mako
    wofi
    waybar
    hyprpaper
    hyprlock
    hypridle

    # applications
    tuba
    cartridges
    blanket
    bottles
    celluloid
    dissent
    keypunch
    libadwaita

    # Hyprland-compatible tools and alternatives
    kitty # terminal emulator (popular with Hyprland)
    thunar # file manager
    pavucontrol # audio control
    brightnessctl # brightness control
    playerctl # media control
    networkmanagerapplet # network management
    blueman # bluetooth management

    # Additional useful tools for Hyprland
    rofi-wayland # alternative launcher
    dunst # alternative notification daemon
    polkit-kde-agent # polkit authentication agent

    # Keep useful tools
    gnome-tweaks # still useful for some GTK settings
  ];

  # Embedded Hyprland configuration with Nord theme
  environment.etc."hypr/hyprland.conf".text = ''
    # Nord Color Scheme
    $nord0 = 0x2e3440
    $nord1 = 0x3b4252
    $nord2 = 0x434c5e
    $nord3 = 0x4c566a
    $nord4 = 0xd8dee9
    $nord5 = 0xe5e9f0
    $nord6 = 0xeceff4
    $nord7 = 0x8fbcbb
    $nord8 = 0x88c0d0
    $nord9 = 0x81a1c1
    $nord10 = 0x5e81ac
    $nord11 = 0xbf616a
    $nord12 = 0xd08770
    $nord13 = 0xebcb8b
    $nord14 = 0xa3be8c
    $nord15 = 0xb48ead

    # Monitor configuration (adjust as needed)
    monitor=,preferred,auto,1

    # Startup applications
    exec-once = waybar
    exec-once = mako
    exec-once = hyprpaper
    exec-once = hypridle

    # Input configuration
    input {
        kb_layout = us
        follow_mouse = 1
        touchpad {
            natural_scroll = yes
        }
        sensitivity = 0
    }

    # General settings
    general {
        gaps_in = 8
        gaps_out = 16
        border_size = 2
        col.active_border = rgb(${builtins.substring 2 6 "$nord8"}) rgb(${builtins.substring 2 6 "$nord9"}) 45deg
        col.inactive_border = rgb(${builtins.substring 2 6 "$nord3"})
        layout = dwindle
        allow_tearing = false
    }

    # Window decorations
    decoration {
        rounding = 8
        blur {
            enabled = true
            size = 6
            passes = 2
            new_optimizations = true
        }
        drop_shadow = yes
        shadow_range = 12
        shadow_render_power = 3
        col.shadow = rgba(2e3440aa)
    }

    # Animations
    animations {
        enabled = yes
        bezier = ease, 0.25, 0.1, 0.25, 1.0
        animation = windows, 1, 6, ease
        animation = windowsOut, 1, 6, ease, popin 80%
        animation = border, 1, 8, ease
        animation = borderangle, 1, 8, ease
        animation = fade, 1, 6, ease
        animation = workspaces, 1, 6, ease
    }

    # Layout configuration
    dwindle {
        pseudotile = yes
        preserve_split = yes
    }

    master {
        new_is_master = true
    }

    # Window rules
    windowrule = float, pavucontrol
    windowrule = float, blueman-manager
    windowrule = float, nm-connection-editor

    # Key bindings
    $mainMod = SUPER

    # Basic bindings
    bind = $mainMod, Return, exec, kitty
    bind = $mainMod, Q, killactive
    bind = $mainMod, M, exit
    bind = $mainMod, E, exec, thunar
    bind = $mainMod, V, togglefloating
    bind = $mainMod, D, exec, wofi --show drun
    bind = $mainMod, P, pseudo
    bind = $mainMod, J, togglesplit

    # Move focus
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d

    # Switch workspaces
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to workspace
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll through workspaces
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # Screenshot bindings
    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
    bind = SHIFT, Print, exec, grim - | wl-copy

    # Volume and brightness controls
    bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ +5%
    bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ -5%
    bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +10%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-
  '';

  # Waybar configuration with Nord theme
  environment.etc."xdg/waybar/config".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 32;
    spacing = 4;

    modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "battery" "clock" "tray" ];

    "hyprland/workspaces" = {
      disable-scroll = true;
      all-outputs = true;
      format = "{icon}";
      format-icons = {
        "1" = "󰋜";
        "2" = "󰈹";
        "3" = "󰘙";
        "4" = "󰙯";
        "5" = "󰎄";
        "6" = "󰋩";
        "7" = "󰄖";
        "8" = "󰑴";
        "9" = "󰎆";
        "10" = "󰿬";
        urgent = "";
        focused = "";
        default = "";
      };
    };

    clock = {
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "{:%Y-%m-%d}";
    };

    cpu = {
      format = "󰘚 {usage}%";
      tooltip = false;
    };

    memory = {
      format = "󰍛 {}%";
    };

    temperature = {
      critical-threshold = 80;
      format = "{icon} {temperatureC}°C";
      format-icons = [ "" "" "" ];
    };

    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-charging = "󰂄 {capacity}%";
      format-plugged = "󰂄 {capacity}%";
      format-alt = "{time} {icon}";
      format-icons = [ "󰂃" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
    };

    network = {
      format-wifi = "󰤨 {essid}";
      format-ethernet = "󰈀 Connected";
      tooltip-format = "󰤨 {ifname} via {gwaddr}";
      format-linked = "󰤭 {ifname} (No IP)";
      format-disconnected = "󰤮 Disconnected";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-bluetooth = "{icon} {volume}%";
      format-bluetooth-muted = "󰝟 {icon}";
      format-muted = "󰝟 {format_source}";
      format-source = "󰍬 {volume}%";
      format-source-muted = "󰍭";
      format-icons = {
        headphone = "󰋋";
        hands-free = "󰋎";
        headset = "󰋎";
        phone = "";
        portable = "";
        car = "";
        default = [ "󰕿" "󰖀" "󰕾" ];
      };
      on-click = "pavucontrol";
    };

    tray = {
      spacing = 10;
    };
  };

  # Waybar CSS with Nord theme
  environment.etc."xdg/waybar/style.css".text = ''
    * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-weight: bold;
        font-size: 13px;
        min-height: 0;
    }

    window#waybar {
        background-color: rgba(46, 52, 64, 0.95);
        border-bottom: 2px solid #81a1c1;
        color: #eceff4;
        transition-property: background-color;
        transition-duration: .5s;
    }

    #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #d8dee9;
        border-bottom: 2px solid transparent;
        transition: all 0.3s ease;
    }

    #workspaces button:hover {
        background: rgba(136, 192, 208, 0.2);
        box-shadow: inset 0 -2px #88c0d0;
    }

    #workspaces button.active {
        background-color: rgba(129, 161, 193, 0.3);
        border-bottom: 2px solid #81a1c1;
        color: #eceff4;
    }

    #workspaces button.urgent {
        background-color: rgba(191, 97, 106, 0.3);
        border-bottom: 2px solid #bf616a;
        color: #eceff4;
    }

    #mode {
        background-color: #bf616a;
        color: #eceff4;
        border-bottom: 2px solid #a54858;
        padding: 0 16px;
    }

    #window,
    #clock,
    #battery,
    #cpu,
    #memory,
    #temperature,
    #network,
    #pulseaudio,
    #tray {
        padding: 0 12px;
        color: #eceff4;
        background-color: rgba(59, 66, 82, 0.8);
        margin: 3px 2px;
        border-radius: 8px;
    }

    #window {
        background-color: rgba(136, 192, 208, 0.2);
        border-bottom: 2px solid #88c0d0;
    }

    #battery.charging, #battery.plugged {
        color: #a3be8c;
        background-color: rgba(163, 190, 140, 0.2);
    }

    @keyframes blink {
        to {
            background-color: rgba(235, 203, 139, 0.5);
            color: #2e3440;
        }
    }

    #battery.critical:not(.charging) {
        background-color: rgba(191, 97, 106, 0.3);
        color: #bf616a;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #cpu {
        background-color: rgba(129, 161, 193, 0.2);
        color: #81a1c1;
    }

    #memory {
        background-color: rgba(163, 190, 140, 0.2);
        color: #a3be8c;
    }

    #temperature {
        background-color: rgba(235, 203, 139, 0.2);
        color: #ebcb8b;
    }

    #temperature.critical {
        background-color: rgba(191, 97, 106, 0.3);
        color: #bf616a;
    }

    #network {
        background-color: rgba(180, 142, 173, 0.2);
        color: #b48ead;
    }

    #network.disconnected {
        background-color: rgba(191, 97, 106, 0.3);
        color: #bf616a;
    }

    #pulseaudio {
        background-color: rgba(208, 135, 112, 0.2);
        color: #d08770;
    }

    #pulseaudio.muted {
        background-color: rgba(191, 97, 106, 0.3);
        color: #bf616a;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: rgba(191, 97, 106, 0.3);
    }
  '';

  # Mako notification configuration with Nord theme
  environment.etc."xdg/mako/config".text = ''
    background-color=#2e3440
    text-color=#eceff4
    border-color=#81a1c1
    border-size=2
    border-radius=8
    default-timeout=5000
    ignore-timeout=1
    font=JetBrainsMono Nerd Font 11
    margin=10
    padding=15
    width=350
    height=150
    anchor=top-right
    layer=overlay

    [urgency=high]
    border-color=#bf616a
    background-color=#3b4252
  '';

  # Enable Hyprland with conditional NVIDIA support
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = builtins.elem "nvidia" config.services.xserver.videoDrivers;
  };

  programs.dconf.enable = true;

  # Keep SSH and keyring functionality
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";
  services.gnome.gnome-keyring.enable = true;

  # Use SDDM with Wayland support
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "hyprland";

  # Keep important services
  services.udev.packages = with pkgs; [
    gnome-settings-daemon # still useful for some hardware integration
  ];

  services.avahi.extraConfig = "
    [publish]
    disable-user-service-publishing=
  ";

  # Audio with PipeWire (recommended for Hyprland)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Essential services for Hyprland
  security.polkit.enable = true;
  services.dbus.enable = true;
  security.pam.services.hyprlock = {};

  # XDG portal configuration for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Keep networking
  networking.networkmanager.enable = true;

  # Keep firewall rules for KDE Connect compatibility
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];

  # Font configuration for better Hyprland experience
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Hardware acceleration and graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA configuration for Hyprland (only on NVIDIA systems)
  hardware.nvidia = pkgs.lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # Use proprietary driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Conditionally set video drivers - override this in your host-specific config
  services.xserver.videoDrivers = pkgs.lib.mkDefault [ ];

  # Environment variables for Hyprland
  environment.sessionVariables = {
    # Universal Wayland variables
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  } // pkgs.lib.optionalAttrs (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
    # NVIDIA-specific variables (only when NVIDIA driver is enabled)
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
  };
}
