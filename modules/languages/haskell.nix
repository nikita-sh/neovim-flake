{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.haskell;
in
{
  options.vim.languages.haskell = {
    enable = mkEnableOption "Haskell language support";
    packages = {
    };

    treesitter = {
      enable = mkOption {
        description = "Enable Haskell treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.options.mkGrammarOption pkgs "haskell";
    };

    lsp = {
      enable = mkOption {
        description = "Haskell LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      package = nvim.options.mkCommandOption pkgs {
      };
      opts = mkOption {
      };
    };

    debugger = {
      enable = mkOption {
        description = "Haskell debugger support";
        type = types.bool;
        default = config.vim.languages.enableDebugger;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })
    (mkIf cfg.lsp.enable {
      vim.startPlugins = [ ];
      vim.lsp.lspconfig.enable = true;
    })
    (mkIf cfg.debugger.enable {
      vim.startPlugins = [ ];
      vim.debugger.enable = true;
    })
  ]);
}
