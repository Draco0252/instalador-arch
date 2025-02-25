-- Configuración de Neovim basada en NvChad
-- Descripción: Este archivo contiene configuraciones detalladas en español,
--							con comentarios sobre cada opción y plugin. Utiliza el gestor de plugins Lazy.


-- Configuración general de Neovim
vim.opt.number = true -- Muestra los números de línea
vim.opt.relativenumber = true -- Números relativos para facilitar la navegación
vim.opt.wrap = false -- No envolver líneas largas
vim.opt.tabstop = 4 -- Tamaño de tabulación
vim.opt.shiftwidth = 4 -- Ancho de indentación automática
vim.opt.mouse = "a" -- Habilitar el uso del ratón en todas las modalidades
vim.opt.clipboard = "unnamedplus" -- Compartir portapapeles del sistema
vim.opt.splitright = true -- Abrir nuevos splits verticales a la derecha
vim.opt.splitbelow = true -- Abrir nuevos splits horizontales abajo
vim.opt.termguicolors = true -- Habilitar colores verdaderos para una mejor apariencia
vim.opt.cursorline = true -- Resaltar la línea actual

-- Cargar el gestor de plugins Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

-- Atajos de teclado generales
vim.g.mapleader = "º" -- Definir la tecla líder como espacio

---------- Mapeos personalizados--------------

vim.keymap.set("n", "<C-g>", ":w<CR>", { desc = "Guardar archivo" }) -- Guardar archivo
vim.keymap.set("n", "<C-s>", ":q!<CR>", { desc = "Cerrar archivo sin guardar" }) -- Cerrar archivo sin guardar
vim.keymap.set("n", "<C-r>", ":source %<CR>", { desc = "Recargar archivo" }) -- Recargar el archivo
-- Dividir horizontalmente
vim.keymap.set('n', '<Leader>b', ':split<CR>', { noremap = true, silent = true })
-- Dividir verticalmente
vim.keymap.set('n', '<Leader>v', ':vsplit<CR>', { noremap = true, silent = true })
-- Moverse hacia la ventana superior
vim.keymap.set('n', '<Leader>k', '<C-w>k', { noremap = true, silent = true })
-- Moverse hacia la ventana inferior
vim.keymap.set('n', '<Leader>j', '<C-w>j', { noremap = true, silent = true })
-- Moverse hacia la ventana izquierda
vim.keymap.set('n', '<Leader>h', '<C-w>h', { noremap = true, silent = true })
-- Moverse hacia la ventana derecha
vim.keymap.set('n', '<Leader>l', '<C-w>l', { noremap = true, silent = true })
-- Incrementar altura
vim.keymap.set('n', '<Leader>+', ':resize +4<CR>', { noremap = true, silent = true })
-- Incrementar ancho
vim.keymap.set('n', '<Leader>>', ':vertical resize +4<CR>', { noremap = true, silent = true })
---- u, es para desacer acciones
vim.keymap.set("n", "<A-u>", "<C-r>", { desc = "Reacer camvios" }) -- Guardar archivo
---------- Mapeos para NERDTree --------------
vim.keymap.set("n", "<C-l>", ":NERDTreeToggle<CR>", { desc = "Abrir o cerrar NERDTree" })
vim.keymap.set("n", "<C-ñ>", ":NERDTreeFind<CR>", { desc = "Buscar archivo en NERDTree" })
---------- Mapeos de Telescope ---------------
vim.keymap.set("n", "<Leader>t", ":Telescope<CR>", { desc = "Ejecuta telescope" }) -- Ejecuta Telescope

--------- Mi Tema ---------
-- Tema básico para Neovim compatible con Tree-sitter
local theme = {}

-- Definimos una paleta de colores básica
	color = {
		bg = "NONE",
		negro = "#101010", -- Fondo transparente
		blanco = "#fdfdfd",
		rojo	= "#f02525",
		verde = "#25f025",
		azul = "#2525f0",
		amarillo = "#f8f025",
		naranja = "#f5a025",
		celeste = "#00ffff",
		gris = "#A1A1A1",
		morado = "#a020f0",
	}

-- Función principal del tema
theme.setup = function()
		-- Configurar los colores projoeterminados
		--vim.o.termguicolor = true
		vim.g.color_name = "mi_tema"

		-- Colores básicos de la interfaz
		vim.api.nvim_set_hl(0, "Normal", { fg = color.blanco, bg = color.bg }) -- Fondo transparente
		vim.api.nvim_set_hl(0, "NormalNC", { fg = color.blanco, bg = color.bg }) -- Ventanas no activas
		vim.api.nvim_set_hl(0, "SignColumn", { bg = color.bg }) -- Columna de signos
		vim.api.nvim_set_hl(0, "LineNr", { fg = color.naranja, bg = color.bg }) -- Números de línea
		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = color.bg, fg = color.amarillo }) -- Indicadores del final del buffer
		vim.api.nvim_set_hl(0, "Comment", { fg = color.gris, italic = true })
		vim.api.nvim_set_hl(0, "Error", { fg = color.rojo, bold = true })
		vim.api.nvim_set_hl(0, "Todo", { fg = color.verde, bold = true })
		vim.api.nvim_set_hl(0, "IblScope", { fg = color.bg, bg = color.bg })

		-- Colores para Tree-sitter
		vim.api.nvim_set_hl(0, "@keyword", { fg = color.morado, bold = true })
		vim.api.nvim_set_hl(0, "@string", { fg = color.verde })
		vim.api.nvim_set_hl(0, "@variable", { fg = color.rojo }) -- Variables en rojo
		vim.api.nvim_set_hl(0, "@function", { fg = color.amarillo, bold = true })
		vim.api.nvim_set_hl(0, "@type", { fg = color.celeste })
		vim.api.nvim_set_hl(0, "@constant", { fg = color.morado })
end

theme.setup()

-- Plugins gestionados por Lazy
require("lazy").setup({

----------- Productividad ------------

	-- Administrador de árbol de archivos
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 30, -- Ancho del panel lateral
					side = "left", -- Lado en el que aparece el árbol
				},
				filters = {
					dotfiles = true, -- Ocultar archivos ocultos
					custom = { "node_modules", ".cache" }, -- Carpetas específicas a excluir
				},
				git = {
					enable = true, -- Mostrar información de git
					ignore = false, -- Ignorar archivos enlistados en .gitignore
				},
				actions = {
					open_file = {
						quit_on_open = true, -- Cerrar Nvim-Tree al abrir un archivo
					},
				},
			})
		end
	},

--							 	section_separators = { left = "", right = "" },
--								component_separators = { left = "", right = "" },

-- Configuración de Lualine
	{
		"nvim-lualine/lualine.nvim",
		config = function()
		require('lualine').setup {
			options = {
				theme = {
					normal = {
						a = { fg = color.negro, bg = color.rojo, gui = 'bold' },
						b = { fg = color.negro, bg = color.gris },
						c = { fg = color.blanco, bg = color.negro },
					},
					insert = {
						a = { fg = color.negro, bg = color.verde, gui = 'bold' },
						b = { fg = color.negro, bg = color.gris },
						c = { fg = color.blanco, bg = color.negro }
					},
					visual = {
						a = { fg = color.negro, bg = color.amarillo, gui = 'bold' },
						b = { fg = color.negro, bg = color.gris },
						c = { fg = color.blanco, bg = color.negro }
					},
					replace = {
						a = { fg = color.negro, bg = color.azul, gui = 'bold' },
						b = { fg = color.negro, bg = color.gris },
						c = { fg = color.blanco, bg = color.negro }
					},
					command = {
						a = { fg = color.negro, bg = color.morado, gui = 'bold' },
						b = { fg = color.negro, bg = color.gris },
						c = { fg = color.blanco, bg = color.negro }
					},
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {'branch'},
					lualine_c = {'filename'},
					lualine_x = {'encoding', 'fileformat', 'filetype'},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				inactive_sections = {
					lualine_a = {'mode'},
					lualine_b = {'branch'},
					lualine_c = {'filename'},
					lualine_x = {'encoding', 'fileformat', 'filetype'},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				extensions = {}
			}
		}
		end
	},
	-- Explorador fuzzy
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					prompt_prefix = "🔍 ", -- Prefijo en la línea de búsqueda
					selection_caret = "➤ ", -- Indicador de selección
					layout_config = {
						horizontal = {
							preview_width = 0.6, -- Tamaño de la vista previa
						},
					},
				},
			})
		end
	},

	-- Exporador de archivos
	{
		"preservim/nerdtree",
		config = function()
				-- Opcional: Configuración personalizada para NERDTree
				vim.g.NERDTreeShowHidden = 1 -- Mostrar archivos ocultos
				vim.g.NERDTreeQuitOnOpen = 1 -- Cerrar NERDTree al abrir un archivo
		end
	},

	-- 
	{ "tpope/vim-surround" },

----------- Lenguages y resaltados -----------

	-- Resaltado de sintaxis
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
						"python",
						"bash",
						"blade",
						"css",
						"go",
						"gomod",
						"html",
						"javascript",
						"json",
						"lua",
						"luadoc",
						--"markdown",
						--"markdown_inline",
						"nix",
						"org",
						--"php",
						--"phpdoc",
						"query",
						"rust",
						"sql",
						"toml",
						--"svelte",
						"typescript",
						--"regex",
						"vim",
						"yaml" }, -- Instalar todos los parsers
				highlight = {
					enable = true, -- Habilitar resaltado de sintaxis
					additional_vim_regex_highlighting = false, -- Usar solo Treesitter
				},
				indent = {
					enable = true, -- Habilitar indentación basada en Treesitter
				},
			})
		end
	},

	-- Servidor de Lenguaje (LSP)
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").pyright.setup({}) -- Configuración para Python
						require("lspconfig").lua_ls.setup({
								settings = {
										Lua = {
												diagnostics = {
														globals = { "vim" }, -- Reconocer "vim" como global
												},
										},
								},
			})
						require("lspconfig").taplo.setup({}) -- Soporte para TOML
		end
	},

	-- Gestor de lenguages MASON
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- Actualiza el registro de herramientas cada vez que instales el plugin
		config = function()
				require("mason").setup({
						ui = {
								icons = {
										package_installed = "✓",
										package_pending = "➜",
										package_uninstalled = "✗",
								},
						},
				})
		end
	},
	{
		"williamboman/mason-lspconfig.nvim", -- Integración con LSP
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "pyright", "lua_ls", "taplo" },
				})
		end
	},

----------- Interfaz -----------------
	-- Autocompletado
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Fuente para LSP
			"hrsh7th/cmp-buffer", -- Fuente para el buffer actual
			"hrsh7th/cmp-path" -- Fuente para rutas de archivos
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = {
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<A-Tab>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true })
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" }
				})
			})
		end
	},

	-- Comillado
	{
		"windwp/nvim-autopairs",
		config = function()
				require("nvim-autopairs").setup({
						check_ts = true, -- Habilitar soporte para Treesitter
				})
		end
	},

	-- Tavulaciones
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
				require("ibl").setup({
						indent = {
								char = "┊", -- Cambia el símbolo de la línea de indentación
						},
						scope = {
								--enabled = true, -- Habilitar líneas de contexto para bloques
						},
				})

		end
	},

	--Menu de inicio
	{
		"nvimdev/dashboard-nvim",
		config = function()
				require("dashboard").setup({
					theme = "hyper", -- Cambiar el diseño visual del menú
					config = {
						header = { -- Encabezado personalizado
							"Bienvenido a Neovim!",
						},
						center = { -- Opciones centrales
							{
								icon = "🔍",
								desc = "Buscar archivo",
								action = "Telescope find_files",
							},
							{
								icon = "📂",
								desc = "Abrir proyecto",
								action = "Telescope projects",
							},
						},
					},
				})
		end
	},

----------- Utilidades varias ------------

	--Reemplaza los mensajes de Neovim con notificaciones más elegantes y visuales.
{
		"rcarriga/nvim-notify",
		config = function()
				require("notify").setup({
						background_colour = "#000000", -- Color de fondo
						timeout = 4000, -- Tiempo en milisegundos antes de cerrar la notificación
						stages = "fade", -- Animación para las notificaciones
				})
				vim.notify = require("notify")
		end,
},

	-- Búsqueda y reemplazo global con una interfaz interactiva.
	{
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
				require("spectre").setup({})
		end
	},

	-- Comentarios rápidos
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup() -- Habilitar funcionalidad para comentar líneas
		end
	},

	-- Vista centralizada de errores, advertencias y diagnósticos de LSP.
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
				require("trouble").setup({
					icons = true, -- Mostrar iconos en la lista de problemas
				})
		end
	},

		-- Pluguin para resaltar colores atrabes de codigo
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
				require("colorizer").setup({
						filetypes = { "*" }, -- Habilitar para todos los tipos de archivo
						user_default_options = {
								RGB = true, -- Soporta #RGB
								RRGGBB = true, -- Soporta #RRGGBB
								names = true, -- Soporta nombres como "rojo"
								RRGGBBAA = true, -- Soporta transparencia #RRGGBBAA
								rgb_fn = true, -- Soporta funciones rgb() y rgba()
								hsl_fn = true, -- Soporta funciones hsl() y hsla()
								css = true, -- Soporta colores CSS
								css_fn = true, -- Soporta funciones CSS
								mode = "background", -- Resalta el fondo del texto
						},
				})
			-- Activar automáticamente en todos los buffers
						vim.cmd("ColorizerAttachToBuffer")
			-- Actualizar dinámicamente los colores al cambiar texto
						vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
								pattern = "*",
								callback = function()
										vim.cmd("ColorizerAttachToBuffer")
								end})
		end
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" }, -- Indicador para líneas añadidas
					change = { text = "~" }, -- Indicador para líneas cambiadas
					delete = { text = "-" }, -- Indicador para líneas eliminadas
				},
				current_line_blame = true, -- Mostrar blame de git en línea actual
			})
		end
	},
})
