local nmap_leader = function(suffix, rhs, desc)
	vim.keymap.set('n' , '<leader>' .. suffix, rhs, { desc = desc })
end

-- k.set('n', '<leader><space>', '<cmd>Telescope find_files<cr>', { desc = 'Find Files' })
nmap_leader('<space>', '<cmd>Telescope find_files<cr>', 'Find Files')
nmap_leader('ff', '<cmd>Telescope find_files<cr>', 'Find Files')
nmap_leader('fr', '<cmd>Telescope find_files<cr>', 'Find Files')
