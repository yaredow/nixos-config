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
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        Preferences = {
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "gfx.webrender.all" = true;
          "widget.dmabuf.force-enabled" = true;

          "browser.tabs.inTitlebar" = 1;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.quitShortcut.disabled" = true;
          "ui.key.menuAccessKeyFocuses" = false;

          "general.autoScroll" = true;
          "widget.disable-workspace-gestures" = true;
          "apz.overscroll.enabled" = true;

          "privacy.webrtc.legacyGlobalIndicator" = false;

          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;

          "layout.css.prefers-color-scheme" = 2;

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
