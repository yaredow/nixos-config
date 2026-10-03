{ ... }:
{
  flake.homeModules.firefox = { ... }: {
    programs.firefox = {
      enable = true;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = false;
        DisableAccounts = false;
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        SearchBar = "unified";

        ExtensionSettings = {
          # uBlock Origin
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        Preferences = {
          # Hardware video acceleration (VA-API on Intel Iris Xe)
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "gfx.webrender.all" = true;
          "widget.dmabuf.force-enabled" = true;

          # Tiling window manager optimizations
          "browser.tabs.inTitlebar" = 1;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.quitShortcut.disabled" = true;
          "ui.key.menuAccessKeyFocuses" = false;

          # Wayland & Scrolling ergonomics
          "general.autoScroll" = true;
          "widget.disable-workspace-gestures" = true;
          "apz.overscroll.enabled" = true;

          # WebRTC screen sharing indicator (prevent separate window from tiling)
          "privacy.webrtc.legacyGlobalIndicator" = false;

          # UI & Compact mode to save vertical screen space
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;

          # Theme & Dark Mode
          "layout.css.prefers-color-scheme" = 2;

          # Clean new tab page & disable sponsored items
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";
          "extensions.pocket.enabled" = false;
        };
      };
    };
  };
}
