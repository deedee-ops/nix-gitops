{ osConfig, pkgs, ... }:
let
  baseSettings = {
    # hardware accelerated video decoding
    "media.ffmpeg.vaapi.enabled" = true;
    "media.rdd-ffmpeg.enabled" = true;
    "media.av1.enabled" = true;
    "widget.dmabuf.force-enabled" = true;
    "gfx.x11-egl.force-enabled" = true;

    # startup
    "browser.newtabpage.enabled" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

    # geolocation
    "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
    "geo.provider.ms-windows-location" = false;
    "geo.provider.use_corelocation" = false;
    "geo.provider.use_gpsd" = false;
    "geo.provider.use_geoclue" = false;

    # disable ads
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.shopping.experience2023.enabled" = false;

    # telemetry
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.ping-centre.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
    "dom.private-attribution.submission.enabled" = false;

    # location bar
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.urlbar.trending.featureGate" = false;
    "browser.urlbar.addons.featureGate" = false;
    "browser.urlbar.mdn.featureGate" = false;
    "browser.urlbar.pocket.featureGate" = false;
    "browser.urlbar.weather.featureGate" = false;
    "browser.formfill.enable" = false;
    "browser.search.separatePrivateDefault" = true;
    "browser.search.separatePrivateDefault.ui.enabled" = true;

    # passwords
    "signon.autofillForms" = false;
    "signon.formlessCapture.enabled" = false;
    "network.auth.subresource-http-auth-allow" = 1;

    # downloads
    "browser.download.useDownloadDir" = false;
    "browser.download.alwaysOpenPanel" = false;
    "browser.download.manager.addToRecentDocs" = false;
    "browser.download.always_ask_before_handling_new_types" = true;

    # tracking
    "browser.contentblocking.category" = "strict";
    "webgl.disabled" = true;

    # misc
    "browser.helperApps.deleteTempFileOnExit" = true;
    "browser.uitour.enabled" = false;
    "dom.security.https_only_mode" = true;
    "network.dns.disableIPv6" = true;

    # expose app links
    "network.protocol-handler.expose.zoommtg" = false;

    # containers
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;
  };

  baseSearch = {
    force = true;
    default = "Whoogle";
    order = [ "Whoogle" ];
    engines = {
      "Whoogle" = {
        urls = [{
          template = "https://whoogle.${osConfig.remoteDomain}/search";
          params = [
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/benbusby/whoogle-search/main/app/static/img/favicon/favicon-96x96.png";
          sha256 = "sha256-erYXYw3N+QBHh35TaI6n+YWMZUQSlN/66SIKMDcnHbA=";
        }}";
      };
    };
  };
in
{
  programs.firefox = {
    enable = true;
    package = null;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "default-off";
      HttpsOnlyMode = "enabled";
      SearchBar = "unified";
    };

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "default";
        search = baseSearch;
        settings = baseSettings // {
          "browser.aboutConfig.showWarning" = false;

          # sync
          "identity.sync.tokenserver.uri" = "https://firefoxsync.${osConfig.remoteDomain}/token/1.0/sync/1.5";
          "identity.sync.useOAuthForSyncToken" = false;

          # startup
          "browser.startup.page" = 1;
          "browser.startup.homepage" = "https://dashboard.${osConfig.remoteDomain}/";
          "ui.systemUsesDarkTheme" = 1;

          # UI
          "browser.uiCustomization.state" = builtins.toJSON
            {
              placements = {
                widget-overflow-fixed-list = [ ];
                unified-extensions-area = [
                  "firefoxcolor_mozilla_com-browser-action"
                  "smart-referer_meh_paranoid_pk-browser-action"
                  "canvasblocker_kkapsner_de-browser-action"
                  "_7fc8ef53-24ec-4205-87a4-1e745953bb0d_-browser-action"
                  "_testpilot-containers-browser-action"
                  "_74145f27-f039-47ce-a470-a662b129930a_-browser-action"
                  "jid1-kkzogwgsw3ao4q_jetpack-browser-action"
                  "polishcookieconsentext_polishannoyancefilters_netlify_com-browser-action"
                  "canvasblocker-beta_kkapsner_de-browser-action"
                  "_7c6d56ed-2616-48f2-bfde-d1830f1cf2ed_-browser-action"
                  "7esoorv3_alefvanoon_anonaddy_me-browser-action"
                ];
                nav-bar = [
                  "back-button"
                  "forward-button"
                  "stop-reload-button"
                  "customizableui-special-spring1"
                  "urlbar-container"
                  "customizableui-special-spring2"
                  "downloads-button"
                  "fxa-toolbar-menu-button"

                  # Extensions
                  "foxyproxy_eric_h_jung-browser-action" # FoxyProxy
                  "containerise_kinte_sh-browser-action" # Containerise
                  "_15b1b2af-e84a-4c70-ac7c-5608b0eeed5a_-browser-action" # Cookiebro
                  "ublock0_raymondhill_net-browser-action" # uBlock Origin
                  "unified-extensions-button"
                ];
                toolbar-menubar = [ "menubar-items" ];
                TabsToolbar = [
                  "tabbrowser-tabs"
                  "new-tab-button"
                  "alltabs-button"
                ];
                PersonalToolbar = [ ];
              };
              # seen = [
              #   "developer-button"
              #   "save-to-pocket-button"
              #   "firefoxcolor_mozilla_com-browser-action"
              #   "ublock0_raymondhill_net-browser-action"
              #   "smart-referer_meh_paranoid_pk-browser-action"
              #   "canvasblocker_kkapsner_de-browser-action"
              #   "_7fc8ef53-24ec-4205-87a4-1e745953bb0d_-browser-action"
              #   "foxyproxy_eric_h_jung-browser-action"
              #   "_testpilot-containers-browser-action"
              #   "_15b1b2af-e84a-4c70-ac7c-5608b0eeed5a_-browser-action"
              #   "_74145f27-f039-47ce-a470-a662b129930a_-browser-action"
              #   "containerise_kinte_sh-browser-action"
              #   "jid1-kkzogwgsw3ao4q_jetpack-browser-action"
              #   "polishcookieconsentext_polishannoyancefilters_netlify_com-browser-action"
              #   "canvasblocker-beta_kkapsner_de-browser-action"
              #   "_7c6d56ed-2616-48f2-bfde-d1830f1cf2ed_-browser-action"
              #   "7esoorv3_alefvanoon_anonaddy_me-browser-action"
              # ];
              # dirtyAreaCache = [
              #   "nav-bar"
              #   "toolbar-menubar"
              #   "TabsToolbar"
              #   "PersonalToolbar"
              #   "unified-extensions-area"
              # ];
              currentVersion = 20;
              newElementCount = 5;
            };
        };
      };
      mail = {
        id = 1;
        isDefault = false;
        name = "mail";
        search = baseSearch;
        settings = baseSettings // {
          "browser.startup.page" = 3;
          "browser.startup.homepage" = "https://ajgon.github.io/firefox-autoclose";
          "dom.allow_scripts_to_close_windows" = true;
        };
      };
    };
  };
}
