{ config
, pkgs
, libs
, ...
}: {

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      golang.go
      rust-lang.rust-analyzer
      bradlc.vscode-tailwindcss
      davidanson.vscode-markdownlint
      dracula-theme.theme-dracula
      # eg2.vscode-npm-script
      esbenp.prettier-vscode
      formulahendry.auto-close-tag
      formulahendry.auto-rename-tag
      formulahendry.code-runner
      prisma.prisma
      github.copilot
      github.copilot-chat
      graphql.vscode-graphql
      irongeek.vscode-env
      mechatroner.rainbow-csv
      mhutchie.git-graph
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode-remote.remote-ssh
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode.makefile-tools
      ms-vsliveshare.vsliveshare
      oderwat.indent-rainbow
      twxs.cmake
      vadimcn.vscode-lldb
      vscjava.vscode-java-dependency
      redhat.java
      ocamllabs.ocaml-platform
      (WakaTime.vscode-wakatime.overrideAttrs (old: {
        postPatch = ''
          mkdir wakatime-cli
          ln -s ${pkgs.wakatime}/bin/wakatime ./wakatime-cli/wakatime-cli
        '';
      }))

    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "aaron-bond";
        name = "better-comments";
        version = "3.0.2";
        sha256 = "sha256-hQmA8PWjf2Nd60v5EAuqqD8LIEu7slrNs8luc3ePgZc=";
      }
      {
        publisher = "jeff-hykin";
        name = "better-cpp-syntax";
        version = "1.17.2";
        sha256 = "sha256-p3SKu9FbtuP6in2dSsr5a0aB5W+YNQ0kMgMJoDYrhcU=";
      }
      # {
      #   publisher = "GitHub";
      #   name = "copilot-chat";
      #   version = "0.11.2023111001";
      #   sha256 = "sha256-sBDvqqyq0R0ZyS81G61fI9Vd860RIjhNzCqY0bdz1mg=";
      # }
    ];

    userSettings = {
      "code-runner.saveFileBeforeRun" = true;
      "code-runner.runInTerminal" = true;
      "code-runner.respectShebang" = false;
      "code-runner.executorMap" = {
        "java" = " javac -d javaclass $fileName; if ($?) {java -cp javaclass $fileNameWithoutExt}";
      };
      "editor.formatOnSave" = true;
      "editor.fontSize" = 12;
      "workbench.startupEditor" = "newUntitledFile";
      "files.autoSave" = "afterDelay";
      "editor.suggestSelection" = "first";
      "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
      "python.showStartPage" = false;
      "python.languageServer" = "Pylance";
      "better-comments.tags" = [
        {
          "tag" = "!";
          "color" = "#FF2D00";
          "strikethrough" = false;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = false;
        }
        {
          "tag" = "?";
          "color" = "#3498DB";
          "strikethrough" = false;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = false;
        }
        {
          "tag" = "//";
          "color" = "#474747";
          "strikethrough" = true;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = false;
        }
        {
          "tag" = "todo";
          "color" = "#FF8C00";
          "strikethrough" = false;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = false;
        }
        {
          "tag" = "*";
          "color" = "#98C379";
          "strikethrough" = false;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = false;
        }
        {
          "tag" = "note";
          "color" = "#cccccc";
          "strikethrough" = false;
          "underline" = false;
          "backgroundColor" = "transparent";
          "bold" = false;
          "italic" = false;
        }
      ];
      "prettier.printWidth" = 100;
      "editor.minimap.maxColumn" = 100;
      "editor.minimap.renderCharacters" = false;
      "editor.minimap.enabled" = true;
      "indentRainbow.indentSetter" = { };
      "indentRainbow.colors" = [
        "rgba(199, 206, 234, 0.2)" #Purple
        "rgba(135, 209, 237, 0.2)" #blue
        "rgba(181, 234, 215, 0.2)" #green
        "rgba(226, 240, 203, 0.2)" #yellow
        "rgba(255, 154, 162, 0.2)" #red
      ];
      "bracketPairColorizer.timeOut" = 0;
      "bracketPairColorizer.activeScopeCSS" = [
        "borderStyle = solid"
        "borderWidth = 1px"
        "borderColor = {color}; opacity: 0.5"
      ];
      "bracketPairColorizer.consecutivePairColors" = [
        [ "<" "</" ]
        [ "<" "/>" ]
        [ "{" "}" ]
        [ "(" ")" ]
        [ "[" "]" ]
        [
          "#CC33FF" #purple
          "#61c3e8" #blue
          "#33FF66" #green
          "#FFCC33" #yellow
          "#ff3366" #red
        ]
        "#ddd" #grey
      ];
      "bracketPairColorizer.highlightActiveScope" = true;
      "editor.detectIndentation" = false;
      "editor.insertSpaces" = true;
      "[python]" = {
        "editor.tabsize" = 4;
        "editor.formatontype" = true;
      };
      "editor.tabsize" = 2;
      "bracketPairColorizer.scopeLineCSS" = [
        "borderStyle = solid"
        "borderWidth = 2px"
        "borderColor = {color}; opacity: 0.5"
      ];
      "bracketPairColorizer.showBracketsInGutter" = true;
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
      };
      "code-runner.customCommand" = "echo Hell";
      "editor.cursorBlinking" = "solid";
      "[javascript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[go]" = {
        "editor.defaultFormatter" = "golang.go";
        "editor.insertSpaces" = false;
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.organizeImports" = true;
        };
        "editor.suggest.snippetsPreventQuickSuggestions" = false;
      };
      "docker.showStartPage" = false;
      "security.workspace.trust.untrustedFiles" = "open";
      "editor.wordWrapColumn" = 120;
      "editor.wrappingIndent" = "indent";
      "editor.wordWrap" = "on";
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "zenMode.fullScreen" = false;
      "zenMode.hideTabs" = false;
      "zenMode.hideStatusBar" = false;
      "zenMode.hideLineNumbers" = false;
      "zenMode.centerLayout" = false;
      "workbench.colorTheme" = "Dracula";
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "terminal.integrated.defaultProfile.windows" = "PowerShell";
      "go.toolsManagement.autoUpdate" = true;
      "go.coverOnSave" = true;
      "go.coverageDecorator" = {
        "type" = "gutter";
        "coveredHighlightColor" = "rgba(64,128,128,0.5)";
        "uncoveredHighlightColor" = "rgba(128,64,64,0.25)";
        "coveredGutterStyle" = "blockgreen";
        "uncoveredGutterStyle" = "blockred";
      };
      "go.coverOnSingleTest" = true;
      "[vue]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "terminal.integrated.defaultProfile.linux" = "tmux";
      "explorer.confirmDelete" = false;
      "java.jdt.ls.vmargs" = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m -javaagent:\"/home/mustafa/.vscode/extensions/gabrielbb.vscode-lombok-1.0.1/server/lombok.jar\"";
      "explorer.confirmDragAndDrop" = false;
      "bracketPairColorizer.depreciation-notice" = false;
      "[javascriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "editor.inlineSuggest.enabled" = true;
      "svelte.enable-ts-plugin" = true;
      "svelte.plugin.svelte.note-new-transformation" = false;
      "github.copilot.enable" = {
        "*" = true;
        "yaml" = false;
        "plaintext" = true;
        "markdown" = false;
      };
      "cmake.configureOnOpen" = true;
      "update.showReleaseNotes" = false;
    };
  };
}
