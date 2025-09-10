{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    defaultKeymap = "emacs";

    history = {
      size = 10000;
      ignoreAllDups = true;
      ignorePatterns = [
        "rm *"
        "pkill *"
        "cp *"
      ];
    };

    initContent = ''
      setopt no_hup
      typeset -UT XDG_DATA_DIRS xdg_data_dirs
    '';

    plugins = [
      {
        name = pkgs.zsh-powerlevel10k.pname;
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = pkgs.zsh-forgit.pname;
        src = pkgs.zsh-forgit;
        file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
      }
    ];
  };
}
