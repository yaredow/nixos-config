local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local datalock = vim.fn.stdpath 'data' .. '/lazy-lock.json'
local configlock = vim.fn.stdpath 'config' .. '/lazy-lock.json'
if not vim.uv.fs_stat(datalock) and vim.uv.fs_stat(configlock) then
  local data = vim.fn.readfile(configlock)
  vim.fn.writefile(data, datalock)
end

require('lazy').setup({
  spec = { import = 'yada.plugins' },
  lockfile = datalock,
  install = { colorscheme = { 'tokyonight-night', 'catppuccin-mocha', 'gruvbox' } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
