
vim.o.guifont = "JetBrainsMono Nerd Font:h12"
-- Transparency (>= 0.14.0)
-- vim.g.neovide_opacity = 0.95
-- vim.g.neovide_normal_opacity = 0.95
-- Titile Bar Color (>= 0.14.0 && Windows-Only)
vim.g.neovide_title_background_color = string.format(
  "%x",
  vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name("Normal")}).bg
)
