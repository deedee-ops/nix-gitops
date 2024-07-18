{ osConfig, ... }:
let
  baseProfileConfig = ''
    // hardware accelerated video decoding
    user_pref("media.ffmpeg.vaapi.enabled", true);
    user_pref("media.rdd-ffmpeg.enabled", true);
    user_pref("media.av1.enabled", true);
    user_pref("widget.dmabuf.force-enabled", true);
    user_pref("gfx.x11-egl.force-enabled", true);

    // startup
    user_pref("browser.newtabpage.enabled", false);
    user_pref("browser.newtabpage.activity-stream.showSponsored", false);
    user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
    user_pref("browser.newtabpage.activity-stream.default.sites", "");
    user_pref("browser.startup.homepage_override.mstone", "ignore");
    user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
    user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

    // geolocation
    user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");
    user_pref("geo.provider.ms-windows-location", false);
    user_pref("geo.provider.use_corelocation", false);
    user_pref("geo.provider.use_gpsd", false);
    user_pref("geo.provider.use_geoclue", false);

    // disable ads
    user_pref("extensions.getAddons.showPane", false);
    user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
    user_pref("browser.discovery.enabled", false);
    user_pref("browser.shopping.experience2023.enabled", false);

    // telemetry
    user_pref("datareporting.policy.dataSubmissionEnabled", false);
    user_pref("datareporting.healthreport.uploadEnabled", false);
    user_pref("toolkit.telemetry.unified", false);
    user_pref("toolkit.telemetry.enabled", false);
    user_pref("toolkit.telemetry.server", "data:,");
    user_pref("toolkit.telemetry.archive.enabled", false);
    user_pref("toolkit.telemetry.newProfilePing.enabled", false);
    user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
    user_pref("toolkit.telemetry.updatePing.enabled", false);
    user_pref("toolkit.telemetry.bhrPing.enabled", false);
    user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
    user_pref("toolkit.telemetry.coverage.opt-out", true);
    user_pref("toolkit.coverage.opt-out", true);
    user_pref("toolkit.coverage.endpoint.base", "");
    user_pref("browser.ping-centre.telemetry", false);
    user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
    user_pref("browser.newtabpage.activity-stream.telemetry", false);
    user_pref("app.shield.optoutstudies.enabled", false);
    user_pref("app.normandy.enabled", false);
    user_pref("app.normandy.api_url", "");
    user_pref("breakpad.reportURL", "");
    user_pref("browser.tabs.crashReporting.sendReport", false);
    user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
    user_pref("dom.private-attribution.submission.enabled", false);

    // location bar
    user_pref("browser.urlbar.speculativeConnect.enabled", false);
    user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
    user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
    user_pref("browser.urlbar.trending.featureGate", false);
    user_pref("browser.urlbar.addons.featureGate", false);
    user_pref("browser.urlbar.mdn.featureGate", false);
    user_pref("browser.urlbar.pocket.featureGate", false);
    user_pref("browser.urlbar.weather.featureGate", false);
    user_pref("browser.formfill.enable", false);
    user_pref("browser.search.separatePrivateDefault", true);
    user_pref("browser.search.separatePrivateDefault.ui.enabled", true);

    // passwords
    user_pref("signon.autofillForms", false);
    user_pref("signon.formlessCapture.enabled", false);
    user_pref("network.auth.subresource-http-auth-allow", 1);

    // downloads
    user_pref("browser.download.useDownloadDir", false);
    user_pref("browser.download.alwaysOpenPanel", false);
    user_pref("browser.download.manager.addToRecentDocs", false);
    user_pref("browser.download.always_ask_before_handling_new_types", true);

    // tracking
    user_pref("browser.contentblocking.category", "strict");
    user_pref("webgl.disabled", true);

    // misc
    user_pref("browser.helperApps.deleteTempFileOnExit", true);
    user_pref("browser.uitour.enabled", false);
    user_pref("dom.security.https_only_mode", true);
    user_pref("network.dns.disableIPv6", true);

    // expose app links
    user_pref('network.protocol-handler.expose.zoommtg', false);

    // containers
    user_pref("privacy.userContext.enabled", true);
    user_pref("privacy.userContext.ui.enabled", true);
  '';
in
{
  programs.firefox = {
    enable = true;
    package = null;

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "default";
        extraConfig = baseProfileConfig + ''
          user_pref("browser.aboutConfig.showWarning", false);

          // sync
          user_pref("identity.sync.tokenserver.uri", "https://firefoxsync.${osConfig.remoteDomain}/token/1.0/sync/1.5");
          user_pref("identity.sync.useOAuthForSyncToken", false);

          // startup
          user_pref("browser.startup.page", 1);
          user_pref("browser.startup.homepage", "https://dashboard.${osConfig.remoteDomain}/");
          user_pref("ui.systemUsesDarkTheme", 1);
        '';
      };
      mail = {
        id = 1;
        isDefault = false;
        name = "mail";
        extraConfig = baseProfileConfig + ''
          user_pref("browser.startup.page", 3);
          user_pref("browser.startup.homepage", "https://ajgon.github.io/firefox-autoclose");
          user_pref("dom.allow_scripts_to_close_windows", true);
        '';
      };
    };
  };
}
