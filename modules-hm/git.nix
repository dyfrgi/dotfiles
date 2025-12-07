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
      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      push.default = "current";
      push.followTags = true;
      rerere.enabled = true;
      rerere.autoupdate = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
      tag.sort = "version:refname";
    };
  };
}
