return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"moyiz/blink-emoji.nvim",
		"Kaiser-Yang/blink-cmp-git",
		"jdrupal-dev/css-vars.nvim",
		"disrupted/blink-cmp-conventional-commits",
	},

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = { preset = "default" },

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = { documentation = { auto_show = true } },
		signature = { enable = true },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"emoji",
				--				"git",
				"css_vars",
				"conventional_commits",
				"ecolog",
			},
			per_filetype = {
				sql = { "snippets", "dadbod", "buffer" },
			},
			providers = {
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15, -- Tune by preference
					opts = { insert = true }, -- Insert emoji (default) or complete its name
					should_show_items = function()
						return vim.tbl_contains(
							-- Enable emoji completion only for git commits and markdown.
							-- By default, enabled for all file-types.
							{ "gitcommit", "markdown" },
							vim.o.filetype
						)
					end,
				},
				git = {
					module = "blink-cmp-git",
					name = "Git",
					opts = {
						git_centers = {
							github = {
								issue = {
									get_token = function()
										return "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"
									end,
								},
								pull_request = {
									get_token = function()
										return "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"
									end,
								},
								mention = {
									get_token = function()
										return "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"
									end,
									get_documentation = function(item)
										local default =
											require("blink-cmp-git.default.github").mention.get_documentation(item)
										default.get_token = function()
											return "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"
										end
										return default
									end,
								},
							},
						},
					},
				},
				css_vars = {
					name = "css-vars",
					module = "css-vars.blink",
					opts = {
						-- WARNING: The search is not optimized to look for variables in JS files.
						-- If you change the search_extensions you might get false positives and weird completion results.
						search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
					},
				},
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
					enabled = function()
						return vim.bo.filetype == "gitcommit"
					end,
					---@module 'blink-cmp-conventional-commits'
					---@type blink-cmp-conventional-commits.Options
					opts = {}, -- none so far
				},
				ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
