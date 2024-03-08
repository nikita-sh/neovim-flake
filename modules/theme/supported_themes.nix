{ config
, pkgs
, lib
, ...
}:
with lib;
with builtins; let
  themeSubmodule.options = {
    setup = mkOption {
      description = "Lua code to initialize theme";
      type = types.str;
    };
    styles = mkOption {
      description = "The available styles for the theme";
      type = with types; nullOr (listOf str);
      default = null;
    };
    defaultStyle = mkOption {
      description = "The default style for the theme";
      type = types.str;
    };
  };

  cfg = config.vim.theme;
  style = cfg.style;
in
{
  options.vim.theme = {
    supportedThemes = mkOption {
      description = "Supported themes";
      type = with types; attrsOf (submodule themeSubmodule);
    };
  };

  config.vim.theme.supportedThemes = {
    onedark = {
      setup = ''
        -- OneDark theme
        require('onedark').setup {
          style = "${cfg.style}"
        }
        require('onedark').load()
      '';
      styles = [ "dark" "darker" "cool" "deep" "warm" "warmer" ];
      defaultStyle = "dark";
    };

    tokyonight = {
      setup = ''
        -- need to set style before colorscheme to apply
        require("tokyonight").setup({
          style = "${cfg.style}",
        })
        vim.cmd[[colorscheme tokyonight]]
      '';
      styles = [ "day" "night" "storm" "moon" ];
      defaultStyle = "night";
    };

    catppuccin = {
      setup = ''
        -- Catppuccin theme
        require('catppuccin').setup {
          flavour = "${cfg.style}"
        }
        -- setup must be called before loading
        vim.cmd.colorscheme "catppuccin"
      '';
      styles = [ "latte" "frappe" "macchiato" "mocha" ];
      defaultStyle = "mocha";
    };

    dracula-nvim = {
      setup = ''
        require('dracula').setup({
	});
        require('dracula').load();
      '';
    };

    dracula = {
      setup = ''
        vim.cmd[[colorscheme dracula]]
      '';
    };

    gruvbox = {
      setup = ''
        -- gruvbox theme
        vim.o.background = "${cfg.style}"
        vim.cmd.colorscheme "gruvbox"
      '';
      styles = [ "dark" "light" ];
      defaultStyle = "dark";
    };

    monokai-pro = {
      setup = ''
        -- monokai 
	require("monokai-pro").setup({
          transparent_background = false,
          terminal_colors = true,
          devicons = true, 
          styles = {
            comment = { italic = true },
            keyword = { italic = true }, 
            type = { italic = true }, 
            storageclass = { italic = true }, 
            structure = { italic = true }, 
            parameter = { italic = true }, 
            annotation = { italic = true },
            tag_attribute = { italic = true }, 
          },
          filter = "pro", 
          inc_search = "background", 
          background_clear = {
            "toggleterm",
            "telescope",
            "renamer",
            "notify",
          },          
	  plugins = {
            bufferline = {
              underline_selected = false,
              underline_visible = false,
            },
            indent_blankline = {
              context_highlight = "default", -- default | pro
              context_start_underline = false,
            },
          },
        })
        vim.cmd[[colorscheme "monokai-pro"]]
      '';
    };
  };
}
