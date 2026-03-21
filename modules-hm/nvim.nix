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
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      catppuccin-nvim
      conform-nvim
      cyberdream-nvim
      fidget-nvim
      flash-nvim
      gitsigns-nvim
      gruvbox-material
      kanagawa-nvim
      lazydev-nvim
      lualine-nvim
      markview-nvim
      meow-yarn-nvim
      mini-nvim
      neorg
      neo-tree-nvim
      neorg
      nightfox-nvim
      nvim-web-devicons
      (nvim-treesitter.withPlugins (_: nvim-treesitter.allGrammars ++ norg-grammars))
      nvim-treesitter-context
      nvim-lspconfig
      oil-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      tokyonight-nvim
      vim-startuptime
      which-key-nvim
      zk-nvim
    ];
    extraPackages = with pkgs; [
      clang-tools
      fzf
      lua-language-server
      marksman
      nixd
      nixfmt-rfc-style
      nodePackages.prettier
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
