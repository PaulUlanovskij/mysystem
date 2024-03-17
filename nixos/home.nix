{ config, pkgs, inputs, ... }:

{
  home.username = "paviel";
  home.homeDirectory = "/home/paviel";

  home.stateVersion = "23.11"; 
  
  imports = [
	  inputs.nix-colors.homeManagerModules.default
#	  ./features/mako.nix
  ];
  
  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;
  
  home.packages = [
    kitty

    pkgs.waybar
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    })
    )
    libnotify
    pkgs.mako

    (pkgs.nerdfonts.override { fonts = [ "DroidSansMono" ]; })
    pkgs.gh
    swww
  
    rofi-wayland
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
      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }

      mason-nvim
      mason-lspconfig-nvim
      {
        plugin = nvim-lspconfig;
		config = toLuaFile ./nvim/plugin/lsp.lua;
	  }
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
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/cmp.lua;
      }
      {
        plugin = undotree;
        config = toLuaFile ./nvim/plugin/undotree.lua;
      }


      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }

      telescope-fzf-native-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
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

	];
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
    '';

  };


programs.hyprland = {
  enable = true;
  nvidiaPatches = true;
  xwayland.enable = true;
};

environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
};

hardware = {
    opengl.enable = true;

    nvidia.modesetting.enable = true;
};

xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

sound.enable = true;
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;
};

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
	"video/png" = [ "mpv.desktop" ];
	"video/jpg" = [ "mpv.desktop" ];
	"video/*" = [ "mpv.desktop" ];
  };

  programs.home-manager.enable = true;
}
