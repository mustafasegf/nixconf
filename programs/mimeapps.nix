{ config
, pkgs
, libs
, ...
}: {
  xdg.mimeApps = {
    enable = false;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "text/calendar" = "userapp-Thunderbird-OM4EI1.desktop";
      "text/plain" = "nvim.desktop";
      "text/csv" = "nvim.desktop";
      "text/javascript" = "nvim.desktop";
      "text/xml" = "nvim.desktop";
      "text/x-shellscript" = "nvim.desktop";
      "application/zip" = "tar.desktop";
      "application/pdf" = "org.kde.okular.desktop";
      "application/x-extension-ics" = "userapp-Thunderbird-OM4EI1.desktop";
      "image/jpeg" = "pinta.desktop";
      "image/jpg" = "pinta.desktop";
      "image/png" = "pinta.desktop";
      "inode/directory" = "thunar.desktop";
      "audio/wav" = "mpv.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/postman" = "Postman.desktop";
      "x-scheme-handler/tg" = "userapp-Telegram Desktop-JPL1B1.desktop";
      "x-scheme-handler/eclipse+command" = "_usr_lib_dbeaver_.desktop";
      "x-scheme-handler/sidequest" = "SideQuest.desktop";
      "x-scheme-handler/webcal" = "google-chrome.desktop";
      "x-scheme-handler/mailto" = "userapp-Thunderbird-OQCEI1.desktop";
      "x-scheme-handler/mid" = "userapp-Thunderbird-OQCEI1.desktop";
      "x-scheme-handler/webcals" = "userapp-Thunderbird-OM4EI1.desktop";
      "x-scheme-handler/discord-402572971681644545" = "discord-402572971681644545.desktop";
      "message/rfc822" = "userapp-Thunderbird-OQCEI1.desktop";
    };
    associations.added = {
      "text/html" = "firefox.desktop;code-oss.desktop;nvim.desktop;wine-extension-txt.desktop;";
      "text/x-go" = "nvim.desktop;";
      "application/pdf" = "okularApplication_pdf.desktop;";
      "application/x-ms-dos-executable" = "wine.desktop;";
      "application/x-java-archive" = "java-java11-openjdk.desktop;";
      "application/sql" = "code-oss.desktop;nvim.desktop;";
      "application/x-navi-animation" = "gimp.desktop;";
      "image/png" = "pinta.desktop;";
      "video/x-matroska" = "vlc.desktop;";
      "video/mp4" = "vlc.desktop;mpv.desktop;";
      "x-scheme-handler/tg" = "userapp-Telegram Desktop-JPL1B1.desktop;";
      "x-scheme-handler/mailto" = "userapp-Thunderbird-OQCEI1.desktop;";
      "x-scheme-handler/mid" = "userapp-Thunderbird-OQCEI1.desktop;";
      "x-scheme-handler/webcal" = "userapp-Thunderbird-OM4EI1.desktop;";
      "x-scheme-handler/webcals" = "userapp-Thunderbird-OM4EI1.desktop;";
    };
  };
}
