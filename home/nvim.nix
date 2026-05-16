{
  pkgs,
  config,
  ...
}:
let
  norg-grammars = with pkgs.tree-sitter-grammars; [
    tree-sitter-norg
    tree-sitter-norg-meta
  ];
  meow-yarn-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "meow.yarn.nvim";
    version = "v0.1.1";
    src = pkgs.fetchFromGitHub {
      owner = "retran";
      repo = "meow.yarn.nvim";
      rev = "v0.1.1";
      sha256 = "sha256-SQ+glfwwJ2H5HG5WW2R3nDaxuHTUzJDCOJy7a73JaxA=";
    };
    dependencies = [ pkgs.vimPlugins.nui-nvim ];
  };
in
{
  programs.neovim = {
    sideloadInitLua = true;
    enable = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      catppuccin-nvim
      conform-nvim
      cyberdream-nvim
      diagram-nvim
      fidget-nvim
      flash-nvim
      vim-fugitive
      gitsigns-nvim
      guess-indent-nvim
      gruvbox-material
      kanagawa-nvim
      image-nvim
      incline-nvim
      lazydev-nvim
      lualine-nvim
      markview-nvim
      meow-yarn-nvim
      mkdnflow-nvim
      mini-nvim
      neorg
      neo-tree-nvim
      neorg
      nightfox-nvim
      nvim-origami
      nvim-web-devicons
      (nvim-treesitter-legacy.withPlugins (_: nvim-treesitter-legacy.allGrammars ++ norg-grammars))
      nvim-treesitter-context
      nvim-lspconfig
      oil-git-status-nvim
      oil-nvim
      snacks-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      tokyonight-nvim
      vim-startuptime
      which-key-nvim
      wrapping-nvim
      zk-nvim
    ];
    extraPackages = with pkgs; [
      clang-tools
      fzf
      imagemagick
      lua-language-server
      marksman
      mermaid-cli
      nixd
      nixfmt
      prettier
      plantuml
      prettierd
      (python3.withPackages (
        p:
        (with p; [
          isort
          python-lsp-server
        ])
      ))
      ruff
      rust-analyzer
      sleek
      vscode-langservers-extracted
    ];
  };

  xdg.configFile."prettierrc.json".text = builtins.toJSON {
    proseWrap = "always";
  };

  home.sessionVariables = {
    PRETTIERD_DEFAULT_CONFIG = "$HOME/${config.xdg.configFile."prettierrc.json".target}";
    ZK_NOTEBOOK_DIR = "$HOME/zk/";
  };
}
