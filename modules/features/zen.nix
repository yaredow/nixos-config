{ inputs, ... }:
{
  flake.homeModules.zen = { ... }: {
    imports = [
      inputs.zen-browser.homeModules.default
    ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      env = {
        MOZ_ENABLE_WAYLAND = "1";
        LIBVA_DRIVER_NAME = "iHD";
        MOZ_WEBRENDER = "1";
      };

      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisablePocket = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        # Pre-installed extensions
        ExtensionSettings = {
          # Vimium C - Blazing fast Vim navigation
          "vimium-c@gdh1995.cn" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
            installation_mode = "force_installed";
          };
          # Tokyo Night Theme (Milav)
          "{4520dc08-80f4-4b2e-982a-c17af42e5e4d}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tokyo-night-milav/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };

      profiles.default = {
        isDefault = true;

        presets = {
          betterfox.enable = true;
        };

        settings = {
          # Hardware video decoding via VA-API on Wayland
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "gfx.webrender.all" = true;
          "gfx.webrender.compositor.force-enabled" = true;
          "layers.gpu-process.enabled" = true;

          # Wayland portal integration
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.mime-handler" = 1;
          "widget.wayland.opaque-region.enabled" = true;

          # Natural trackpad kinetic scrolling
          "general.smoothScroll.msdPhysics.enabled" = true;
          "apz.overscroll.enabled" = true;

          # WebRTC PipeWire support
          "media.webrtc.hw.h264.enabled" = true;
          "zen.view.compact.hide-toolbar" = false;
        };
      };
    };
  };
}
