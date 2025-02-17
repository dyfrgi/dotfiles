{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      (pkgs-unstable.vimPlugins.blink-cmp)
      catppuccin-nvim
      conform-nvim
      fidget-nvim
      flash-nvim
      gitsigns-nvim
      lazydev-nvim
      lualine-nvim
      mini-nvim
      neo-tree-nvim
      nvim-web-devicons
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-lspconfig
      telescope-nvim
      telescope-fzf-native-nvim
      tokyonight-nvim
      vim-startuptime
      which-key-nvim
    ];
    extraPackages = with pkgs; [
      fzf
      lua-language-server
      nixd
      nixfmt-rfc-style
      rust-analyzer
    ];
  };
}

/*
  List of all plugins installed in nvim:
    "LuaSnip": { "branch": "master", "commit": "33b06d72d220aa56a7ce80a0dd6f06c70cd82b9d" },
    "cmp-buffer": { "branch": "main", "commit": "3022dbc9166796b644a841a02de8dd1cc1d311fa" },
    "cmp-nvim-lsp": { "branch": "main", "commit": "99290b3ec1322070bcfb9e846450a46f6efa50f0" },
    "cmp-path": { "branch": "main", "commit": "91ff86cd9c29299a64f968ebb45846c485725f23" },
    "cmp_luasnip": { "branch": "master", "commit": "98d9cb5c2c38532bd9bdb481067b20fea8f32e90" },
    "dressing.nvim": { "branch": "master", "commit": "3a45525bb182730fe462325c99395529308f431e" },
    "flash.nvim": { "branch": "main", "commit": "34c7be146a91fec3555c33fe89c7d643f6ef5cf1" },
    "friendly-snippets": { "branch": "main", "commit": "efff286dd74c22f731cdec26a70b46e5b203c619" },
    "gitsigns.nvim": { "branch": "main", "commit": "5f808b5e4fef30bd8aca1b803b4e555da07fc412" },
    "indent-blankline.nvim": { "branch": "master", "commit": "259357fa4097e232730341fa60988087d189193a" },
    "lazy.nvim": { "branch": "main", "commit": "7e6c863bc7563efbdd757a310d17ebc95166cef3" },
    "lazydev.nvim": { "branch": "main", "commit": "8620f82ee3f59ff2187647167b6b47387a13a018" },
    "lualine.nvim": { "branch": "master", "commit": "2a5bae925481f999263d6f5ed8361baef8df4f83" },
    "mini.ai": { "branch": "main", "commit": "ebb04799794a7f94628153991e6334c3304961b8" },
    "mini.bufremove": { "branch": "main", "commit": "285bdac9596ee7375db50c0f76ed04336dcd2685" },
    "mini.comment": { "branch": "main", "commit": "a56581c40c19fa26f2b39da72504398de3173c5a" },
    "mini.indentscope": { "branch": "main", "commit": "da9af64649e114aa79480c238fd23f6524bc0903" },
    "mini.pairs": { "branch": "main", "commit": "7e834c5937d95364cc1740e20d673afe2d034cdb" },
    "mini.surround": { "branch": "main", "commit": "aa5e245829dd12d8ff0c96ef11da28681d6049aa" },
    "neo-tree.nvim": { "branch": "v3.x", "commit": "a77af2e764c5ed4038d27d1c463fa49cd4794e07" },
    "nui.nvim": { "branch": "main", "commit": "53e907ffe5eedebdca1cd503b00aa8692068ca46" },
    "nvim-cmp": { "branch": "main", "commit": "b555203ce4bd7ff6192e759af3362f9d217e8c89" },
    "nvim-lspconfig": { "branch": "master", "commit": "8b15a1a597a59f4f5306fad9adfe99454feab743" },
    "nvim-notify": { "branch": "master", "commit": "c3797193536711b5d8983975791c4b11dc35ab3a" },
    "nvim-spectre": { "branch": "master", "commit": "08be31c104df3b4b049607694ebb2b6ced4f928b" },
    "nvim-treesitter": { "branch": "master", "commit": "a295ba13d27684e8904e8e51876b84ee85135cf1" },
    "nvim-treesitter-context": { "branch": "master", "commit": "2bcf700b59bc92850ca83a1c02e86ba832e0fae0" },
    "nvim-treesitter-textobjects": { "branch": "master", "commit": "ad8f0a472148c3e0ae9851e26a722ee4e29b1595" },
    "nvim-ts-autotag": { "branch": "main", "commit": "1cca23c9da708047922d3895a71032bc0449c52d" },
    "nvim-ts-context-commentstring": { "branch": "main", "commit": "1b212c2eee76d787bbea6aa5e92a2b534e7b4f8f" },
    "nvim-web-devicons": { "branch": "master", "commit": "4adeeaa7a32d46cf3b5833341358c797304f950a" },
    "plenary.nvim": { "branch": "master", "commit": "2d9b06177a975543726ce5c73fca176cedbffe9d" },
    "suda.vim": { "branch": "master", "commit": "9adda7d195222d4e2854efb2a88005a120296c47" },
    "telescope.nvim": { "branch": "master", "commit": "2eca9ba22002184ac05eddbe47a7fe2d5a384dfc" },
    "tokyonight.nvim": { "branch": "main", "commit": "45d22cf0e1b93476d3b6d362d720412b3d34465c" },
    "trouble.nvim": { "branch": "main", "commit": "46cf952fc115f4c2b98d4e208ed1e2dce08c9bf6" },
    "vim-illuminate": { "branch": "master", "commit": "5eeb7951fc630682c322e88a9bbdae5c224ff0aa" },
    "vim-startuptime": { "branch": "master", "commit": "ac2cccb5be617672add1f4f3c0a55ce99ba34e01" },
    "which-key.nvim": { "branch": "main", "commit": "8ab96b38a2530eacba5be717f52e04601eb59326" }
*/
