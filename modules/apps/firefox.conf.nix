pkgs: {
  enable = true;
  package = pkgs.firefox-devedition;
  profiles = {
    "default" = {
      id = 0;

      search = {
        default = "DuckDuckGoo";
        privateDefault = "DuckDuckGoo";
        engines = {
          "ddg".metaData.hidden = true;
          "google".metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
          "ddg" = {
            urls = [
              {
                template = "https://duckduckgo.com/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@ddg"];
          };
          "google" = {
            urls = [
              {
                template = "https://google.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@g"];
          };
          "wikipedia" = {
            urls = [
              {
                template = "https://en.wikipedia.org/wiki/Special:Search";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@wiki"];
          };
          "youTube" = {
            urls = [
              {
                template = "https://youtube.com/results";
                params = [
                  {
                    name = "search_query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@yt"];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@np"];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@no"];
          };
          "Nix Wiki" = {
            urls = [
              {
                template = "https://wiki.nixos.org/w/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@nw"];
          };
          "Arch Wiki" = {
            urls = [
              {
                template = "https://wiki.archlinux.org/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                  {
                    name = "fulltext";
                    value = "1";
                  }
                ];
              }
            ];
            definedAliases = ["@aw"];
          };
          "Github" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "repositories";
                  }
                ];
              }
            ];
            definedAliases = ["@gh"];
          };
        };
        force = true;
        order = [
          "ddg"
          "googlee"
          "wikipedia"
          "youTube"
          "Nix Packages"
          "Nix Options"
          "Arch Wiki"
          "Github"
        ];
      };

      bookmarks = {};

      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.addedImportButton" = false;
        "browser.link.open_newwindow" = 2;
        "browser.newtabpage.enabled" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.blankWindow" = true;
        "browser.startup.page" = 3;
        "browser.tabs.closeWindowWithLastTab" = true;
        "browser.tabs.opentabfor.middleclick" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.translation.enable" = true;
        "dom.security.https_only_mode" = true;
        "extensions.pocket.enabled" = false;
        "gfx.webrender.all" = true;
        "identity.fxaccounts.enabled" = false;
        "media.cache_readhead_limit" = 9999;
        "media.cache_resume_threshold" = 9999;
        "medai.ffmpeg.vaapi.enabled" = true;
        "media.videocontrols.picture-in-picture.enabled" = true;
        "signon.rememberSignons" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        sponsorblock
        ublock-origin
        enhancer-for-youtube
        firefox-color
        purpleadblock
      ];

      userChrome = ''
        #TabsToolbar-customization-target { visibility: collapse !important; }
      '';
    };
  };
}
