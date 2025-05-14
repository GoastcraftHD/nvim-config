vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", {desc="Open Parent Directory in Oil"})
vim.keymap.set("n", "od", function() vim.diagnostic.open_float() end, {desc="[O]pen [D]iagnostics in Float"})
