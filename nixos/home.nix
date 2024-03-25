{ config, pkgs, inputs, ... }:
{
  home.username = "paviel";
  home.homeDirectory = "/home/paviel";

  home.stateVersion = "23.11"; 
  
  imports = [
	  inputs.nix-colors.homeManagerModules.default
      ../features/mako.nix
  ];
  
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
  
  home.packages = [
 
    (pkgs.nerdfonts.override { fonts = [ "DroidSansMono" ]; })
    pkgs.gh
    pkgs.zig
    pkgs.zls

  ];

  home.file = {

  };
  home.sessionVariables = {
     EDITOR = "nvim";
  };

  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  in 
  {
	enable = true;

	viAlias = true;
	vimAlias = true;
	vimdiffAlias = true;

    extraPackages = with pkgs; [
		xclip
		wl-clipboard

		lua-language-server
		
	];
	
	plugins = with pkgs.vimPlugins; [

      telescope-fzf-native-nvim
      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }
      telescope-ui-select-nvim

      #LSP
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugin/lsp.lua;
      }
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/cmp.lua;
      }
      luasnip
      cmp_luasnip
      #END LSP

	  {
		plugin = rose-pine;
		config = toLuaFile ./nvim/plugin/rose-pine.lua;
	  }
      {
        plugin = harpoon2;
        config = toLuaFile ./nvim/plugin/harpoon.lua;
      }

	  neodev-nvim

      {
        plugin = undotree;
        config = toLuaFile ./nvim/plugin/undotree.lua;
      }

      friendly-snippets


      lualine-nvim
      nvim-web-devicons

      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json
        ]));
        config = toLuaFile ./nvim/plugin/treesitter.lua;
      }

      vim-nix
      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }

	];
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
    '';

  };

  

xdg.portal.enable = true;
xdg.portal.config.common.default = "*";
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

programs.git = {
	enable = true;
    userName = "PaulUlanovskij";
	userEmail = "ulanovskijpasa@gmail.com";
	aliases = {
	  pu = "push";
	  co = "checkout";
	  cm = "commit";
	};
  };
 
  xdg.mimeApps.defaultApplications = {
	"text/plain" = [ "neovide.desktop" ];
	"application/pdf" = [ "zathura.desktop" ];
	"image/*" = [ "sxiv.desktop" ];
	"video/png" = [ "meh.desktop" ];
	"video/jpg" = [ "meh.desktop" ];
	"video/*" = [ "mpv.desktop" ];
  };

  programs.home-manager.enable = true;
}
