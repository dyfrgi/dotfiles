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
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      catppuccin-nvim
      conform-nvim
      fidget-nvim
      flash-nvim
      gitsigns-nvim
      lazydev-nvim
      lualine-nvim
      markview-nvim
      mini-nvim
      neorg
      neo-tree-nvim
      neorg
      nvim-web-devicons
      (nvim-treesitter.withPlugins (_: nvim-treesitter.allGrammars ++ norg-grammars))
      nvim-treesitter-context
      nvim-lspconfig
      telescope-nvim
      telescope-fzf-native-nvim
      tokyonight-nvim
      vim-startuptime
      which-key-nvim
      zk-nvim
    ];
    extraPackages = with pkgs; [
      fzf
      lua-language-server
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
