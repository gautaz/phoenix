{plugins, ...}: {
  config = ''
    require('ibl').setup{
      -- see https://github.com/lukas-reineke/indent-blankline.nvim/issues/648#issuecomment-1751038734
      scope = {
        highlight = { "SpecialKey", "SpecialKey", "SpecialKey" },
      }
    }
  '';
  plugin = plugins.indent-blankline-nvim;
  type = "lua";
}
