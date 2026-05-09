{
  ...
}:
{
  home.shellAliases = {
    gc = "git commit";
    gca = "git commit -a";
    gcam = "git commit -a -m";
    gs = "git status";
  };
  programs.delta = {
    enableGitIntegration = true;
    enable = true;
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [
      "*~"
      "*.swp"
    ];
    settings = {
      user.name = "Michael Leuchtenburg";
      user.email = "michael@slashhome.org";
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.verbose = true;
      diff.colorMoved = true;
      diff.mnemonicPrefix = true;
      diff.renames = true;
      fetch.all = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      format.pretty = "fuller";
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      log.date = "iso";
      log.stat = true;
      push.default = "current";
      push.followTags = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
      rerere.autoupdate = true;
      rerere.enabled = true;
      tag.sort = "version:refname";
    };
  };
}
