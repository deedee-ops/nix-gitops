return {
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "ansiblels", "bashls", "golangci_lint_ls", "gopls", "jsonls", "lua_ls", "nil_ls", "yamlls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

      lspconfig.ansiblels.setup({})
			lspconfig.bashls.setup({})
			lspconfig.golangci_lint_ls.setup({})
			lspconfig.gopls.setup({})
			lspconfig.jsonls.setup({})
			lspconfig.lua_ls.setup({})
			lspconfig.nil_ls.setup({})
			lspconfig.rubocop.setup({
				cmd = { "bundle", "exec", "rubocop", "--lsp" },
			})
			lspconfig.solargraph.setup({
				cmd = { "bundle", "exec", "solargraph", "stdio" },
			})
      lspconfig.yamlls.setup({})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set({ "n", "v" }, "gc", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gf", function()
				vim.lsp.buf.format({ async = true })
			end, {})
			vim.keymap.set("n", "gh", vim.diagnostic.goto_prev, {})
			vim.keymap.set("n", "gl", vim.diagnostic.goto_next, {})
			vim.keymap.set("n", "gj", vim.diagnostic.open_float, {})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.golines.with({
            extra_args = {"-m", "160", "-t", "2"}
          }),
					null_ls.builtins.formatting.nixpkgs_fmt,
					-- null_ls.builtins.formatting.rubocop,
					null_ls.builtins.formatting.stylua,

					-- null_ls.builtins.diagnostics.golangci_lint,
					null_ls.builtins.diagnostics.hadolint,
					-- null_ls.builtins.diagnostics.rubocop,
					null_ls.builtins.diagnostics.yamllint,
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = { "goimports", "golines", "hadolint", "nixpkgs-fmt", "stylua", "yamllint" },
			})
		end,
	},
}
