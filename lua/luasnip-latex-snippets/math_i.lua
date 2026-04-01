local M = {}

local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

function M.retrieve(is_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    wordTrig = false,
    condition = pipe({ is_math }),
    show_condition = is_math,
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "sum", name = "sum" }, "\\sum_{n=${1:0}}^{${2:\\infty}} ${3:a_n x^n}"),

    parse_snippet(
      { trig = "taylor", name = "taylor" },
      "\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a)^$1 $0"
    ),

    parse_snippet({ trig = "lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}} "),

    parse_snippet({ trig = "limsup", name = "limsup" }, "\\limsup_{${1:n} \\to ${2:\\infty}} "),

    parse_snippet({ trig = "binom", name = "binomial" }, "\\binom{${1:n}}{${2:k}}" ),

    parse_snippet(
      { trig = "prod", name = "product" },
      "\\prod_{${1:n=${2:1}}}^{${3:\\infty}} ${4:${TM_SELECTED_TEXT}} $0"
    ),

    parse_snippet(
      { trig = "part", name = "partial d/dx" },
      "\\frac{\\partial ${1:V}}{\\partial ${2:x}} $0"
    ),

    parse_snippet(
        { trig = "dxd", name = "dx" },
        "\\mathrm{d}${1:x} $0"
    ),
    parse_snippet(
      { trig = "dydx", name = "dy/dx" },
      "\\frac{\\mathrm{d}${1:y}}{\\mathrm{d}${2:x}} $0"
    ),

    parse_snippet(
        { trig = "ddx", name = "d/dx"},
        "\\frac{\\mathrm{d}}{\\mathrm{d}${1:x}} $0"
    ),
    
    parse_snippet(
        { trig = "Dydx", name = "nth derivative da/dx"},
        "\\frac{\\mathrm{d}^{${1:n}}${2:y}}{\\mathrm{d}${3:x}^{${1:n}}} $0"

    ),

    parse_snippet(
        { trig = "Ddx", name = "nth derivative d/dx"},
        "\\frac{\\mathrm{d}^{${1:n}}}{\\mathrm{d}${2:x}^{${1:n}}} $0"
    ), 

    parse_snippet(
        { trig = "rm", name = "mathrm"},
        "\\mathrm{${1}}$0"
    ),

    parse_snippet({ trig = "pmat", name = "pmat" }, "\\begin{pmatrix} $1 \\end{pmatrix} $0"),

    parse_snippet(
      { trig = "lr", name = "left( right)" },
      "\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"
    ),
    parse_snippet(
      { trig = "lr(", name = "left( right)" },
      "\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"
    ),
    parse_snippet(
      { trig = "lr|", name = "left| right|" },
      "\\left| ${1:${TM_SELECTED_TEXT}} \\right| $0"
    ),
    parse_snippet(
      { trig = "lr{", name = "left{ right}" },
      "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"
    ),
    parse_snippet(
      { trig = "lr[", name = "left[ right]" },
      "\\left[ ${1:${TM_SELECTED_TEXT}} \\right] $0"
    ),
    parse_snippet(
      { trig = "lra", name = "leftangle rightangle" },
      "\\langle ${1:${TM_SELECTED_TEXT}} \\rangle $0"
    ),

    parse_snippet(
      { trig = "lrb", name = "left\\{ right\\}" },
      "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"
    ),

    parse_snippet(
      { trig = "sequence", name = "Sequence indexed by n, from m to infinity" },
      "(${1:a}_${2:n})_{${2:n}=${3:m}}^{${4:\\infty}}"
    ),
  }
end

return M
