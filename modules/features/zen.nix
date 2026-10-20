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

          # Zen native Tokyo Night accent and dark mode
          "zen.theme.accent-color" = "#7aa2f7";
          "zen.view.window.scheme" = 0; # 0 = dark mode, 1 = light mode
          "zen.theme.gradient" = false; # disable default purple gradient
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "ui.systemUsesDarkTheme" = 1;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        # Complete Tokyo Night UI Stylesheet for Zen Browser
        userChrome = ''
          :root {
            /* Tokyo Night Color Palette */
            --zen-primary-color: #7aa2f7 !important;
            --zen-colors-primary: #24283b !important;
            --zen-colors-secondary: #24283b !important;
            --zen-colors-tertiary: #1a1b26 !important;
            --zen-colors-border: #414868 !important;

            --zen-main-browser-background: #1a1b26 !important;
            --zen-themed-toolbar-bg: #13141c !important;
            --toolbox-bgcolor-inactive: #13141c !important;
            --toolbar-bgcolor: #1a1b26 !important;
            --newtab-background-color: #1a1b26 !important;

            --toolbarbutton-icon-fill: #7aa2f7 !important;
            --lwt-text-color: #c0caf5 !important;
            --toolbar-color: #c0caf5 !important;
            --toolbar-field-color: #c0caf5 !important;
            --toolbar-field-focus-color: #c0caf5 !important;
            --tab-selected-textcolor: #7aa2f7 !important;
            --newtab-text-primary-color: #c0caf5 !important;
            --arrowpanel-color: #c0caf5 !important;
            --arrowpanel-background: #1a1b26 !important;
            --sidebar-text-color: #c0caf5 !important;
            --lwt-sidebar-text-color: #c0caf5 !important;
            --lwt-sidebar-background-color: #13141c !important;
          }

          /* Zen Titlebar & Toolbar Backgrounds */
          hbox#titlebar,
          #TabsToolbar,
          #zen-appcontent-navbar-container,
          #sidebar-box,
          #sidebar-header,
          #zen-sidebar-web-panel,
          #zen-sidebar-tabs-wrapper {
            background-color: #13141c !important;
          }

          /* URL Bar Tokyo Night */
          .urlbar-background {
            background-color: #24283b !important;
            border: 1px solid #414868 !important;
          }

          #urlbar[focused="true"] .urlbar-background {
            border-color: #7aa2f7 !important;
          }

          .urlbarView-url {
            color: #7aa2f7 !important;
          }

          /* Active & Hover Tab Styling */
          .tabbrowser-tab[selected="true"] .tab-background,
          .tab-background[selected=""] {
            background-color: #24283b !important;
            border-left: 3px solid #7aa2f7 !important;
          }

          .tabbrowser-tab:hover:not([selected="true"]) .tab-background {
            background-color: rgba(36, 40, 59, 0.6) !important;
          }

          /* Zen Workspace Button */
          #zen-workspaces-button {
            background-color: #1a1b26 !important;
            border: 1px solid #414868 !important;
          }

          .sidebar-placesTree {
            background-color: #1a1b26 !important;
          }
        '';

        # Tokyo Night Styling for about: pages and Vimium C
        userContent = ''
          /* Internal about: pages */
          @-moz-document url-prefix("about:") {
            :root {
              --in-content-page-color: #c0caf5 !important;
              --in-content-page-background: #1a1b26 !important;
              --color-accent-primary: #7aa2f7 !important;
              background-color: #1a1b26 !important;
            }
          }

          @-moz-document url("about:newtab"), url("about:home") {
            :root {
              --newtab-background-color: #1a1b26 !important;
              --newtab-background-color-secondary: #24283b !important;
              --newtab-element-hover-color: #24283b !important;
              --newtab-text-primary-color: #c0caf5 !important;
              --newtab-primary-action-background: #7aa2f7 !important;
            }

            .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title {
              color: #7aa2f7 !important;
            }
          }

          @-moz-document url-prefix("about:preferences") {
            :root {
              --zen-colors-tertiary: #13141c !important;
              --in-content-text-color: #c0caf5 !important;
              --link-color: #7aa2f7 !important;
              --zen-colors-primary: #24283b !important;
              --in-content-box-background: #24283b !important;
              --zen-primary-color: #7aa2f7 !important;
            }

            groupbox, moz-card {
              background: #1a1b26 !important;
            }

            button, groupbox menulist {
              background: #24283b !important;
              color: #c0caf5 !important;
            }

            .main-content {
              background-color: #13141c !important;
            }
          }

          /* Vimium C Tokyo Night Link Hints */
          div.vimiumReset.vimiumHintMarker,
          span.vimiumReset.vimiumHintMarker {
            background: #7aa2f7 !important;
            color: #1a1b26 !important;
            border: 1px solid #414868 !important;
            box-shadow: 0 2px 4px rgba(21, 22, 30, 0.6) !important;
            font-family: "JetBrainsMono Nerd Font", monospace !important;
            font-size: 12px !important;
            font-weight: 700 !important;
            padding: 1px 4px !important;
            border-radius: 4px !important;
          }

          div.vimiumReset.vimiumHintMarker span {
            color: #1a1b26 !important;
            font-weight: 700 !important;
          }
        '';
      };
    };
  };
}
