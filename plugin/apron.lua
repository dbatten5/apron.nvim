-- Guard against loading the plugin more than once.
if vim.g.loaded_apron then
  return
end
vim.g.loaded_apron = true
