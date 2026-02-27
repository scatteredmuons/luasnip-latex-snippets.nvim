local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node

local M = {}

function M.retrieve(not_math)

local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

local conds = require("luasnip.extras.expand_conditions")
local condition = pipe({ conds.line_begin, not_math })

local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = condition,
}) --[[@as function]]

local s = ls.extend_decorator.apply(ls.snippet, {
    condition = condition,
}) --[[@as function]]

return{
    -- Notes
    s({trig = "packages!", name = "Boilerplate packages"},
        { t({ [[ 
        \usepackage{mathtools}
        \usepackage{amssymb}
        \usepackage{amsfonts}
        \usepackage{siunitx}
        \usepackage{tensor}
        \usepackage{slashed}
        \usepackage{placeins}
        \usepackage{geometry}
        \usepackage{graphicx}
        \usepackage{xcolor}
        \usepackage{biblatex}
        \usepackage{cleveref}
        \usepackage{fancyhdr}
        \usepackage{extramarks}
        \usepackage{tikz}
        \usepackage{array}
        \usepackage[plain]{algorithm}
        \usepackage{algpseudocode}
        \usepackage{svg}
        \usepackage{listings}
        ]] })
    ),
}
end 

return M

