-- 基本设置 (保留原vim配置)
vim.o.compatible = false
-- vim.o.t_Co = 256
vim.o.updatetime = 500
vim.g.encoding = "utf-8"
vim.g.termencoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.fileencodings = "ucs-bom,utf-8,gb2312,cp936,gbk,gb18030,big5,euc-jp,euc-kr,latin1"
vim.o.ruler = true
vim.o.showmatch = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.linebreak = true
vim.o.statusline = ""
vim.o.laststatus = 2
vim.wo.wrap = false
vim.wo.number = true
vim.o.vb = true
vim.o.background = "dark"
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.smarttab = true
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.list = true
vim.o.listchars = "tab:¦ "
vim.o.cindent = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cinoptions = ":0g0t0(susj1"
vim.o.backspace = "indent,eol,start"
vim.o.whichwrap = "b,s,<,>,[,]"
vim.o.mouse = "a"
vim.o.selectmode = ""
vim.o.mousemodel = "popup"
vim.o.keymodel = "startsel,stopsel"
vim.o.selection = "exclusive"
vim.o.ignorecase = true
vim.wo.cursorcolumn = false
vim.wo.cursorline = true
vim.o.wildmode = "longest,list,full"
vim.o.wildmenu = true
vim.g.completeopt = "menu,menuone,noselect"
vim.o.shada = "'20,<50,s10"
vim.o.autoread = true
vim.bo.autoread = true

-- 主题设置
vim.cmd.colorscheme("tokyonight-moon")

-- 字体设置
vim.o.guifont = "CodeNewRoman Nerd Font:h12:cANSI"

