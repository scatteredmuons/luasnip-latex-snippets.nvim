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

return {
    s({ trig = "sct", name = "Unnumbered section" },
        { t({ "\\section*{" }), i(1), t({ "}", "\t" }) }
    ),

    s({ trig = "bct", name = "Unnumbered subsection" },
        { t({ "\\subsection*{" }), i(1), t({ "}", "\t" }) }
    ),

    s({ trig = "cct", name = "Unnumbered subsubsection" },
        { t({ "\\subsubsection*{" }), i(1), t({ "}", "\t" }) }
    ),

    s({ trig = "beq", name = "Numbered equation" },
        { t({ "\\begin{equation}", "\t" }), i(1), t({ "", "\\end{equation}" }) }
    ),

    s({ trig = "Sct", name = "Numbered section" },
        { t({ "\\section{" }), i(1), t({ "}", "\t" }) }
    ),

    s({ trig = "Bct", name = "Numbered subsection" },
        { t({ "\\subsection*{" }), i(1), t({ "}", "\t" }) }
    ),

    s({ trig = "Cct", name = "Numbered subsubsection" },
        { t({ "\\subsubsection*{" }), i(1), t({ "}", "\t" }) }
    ),

    s({ trig = "rseq", name = "Reset equation counter" },
        { t({ "\\setcounter{equation}{0}" }) }
    ),

    s({ trig = "enum", name = "Enumerate" },
        { t({ "\\begin{enumerate}", "\t" }), i(1), t({ "", "\\end{enumerate}" }) }
    ),

    s({ trig = "prop", name = "Proposition (no number)" },
        { t({ "\\begin{proposition*}", "\t" }), i(1), t({ "", "\\end{proposition*}" }) }
    ),

    s({ trig = "pron", name = "Numbered proposition" },
        { t({ "\\begin{proposition}", "\t" }), i(1), t({ "", "\\end{proposition}" }) }
    ),

    s({ trig = "examp", name = "Example" },
        { t({ "\\begin{example}", "\t" }), i(1), t({ "", "\\end{example}" }) }
    ),

    s({ trig = "sltn", name = "Solution" },
        { t({ "\\begin{solution}", "\t" }), i(1), t({ "", "\\end{solution}" }) }
    ),

    s({ trig = "proof", name = "Proof" },
        { t({ "\\begin{proof}", "\t" }), i(1), t({ "", "\\end{proof}" }) }
    ),

    s({ trig = "itemize", name = "Itemize" },
        { t({ "\\begin{itemize}", "\t" }), i(1), t({ "", "\\end{itemize}" }) }
    ),

    s({ trig = "iit", name = "item" },
        { t({ "\\item" }), i(1) }
    ),

    s({ trig = "ali", name = "Align" },
        { t({ "\\begin{align*}", "\t" }), i(1), t({ "", "\\end{align*}" }) }
    ),

    s({ trig = "nli", name = "Numbered align" },
        { t({ "\\begin{align}", "\t" }), i(1), t({ "", "\\end{align}" }) }
    ),
    
    parse_snippet({ trig = "beg", name = "begin{} / end{}" }, "\\begin{$1}\n\t$0\n\\end{$1}"),

    s({ trig = "bx", name = "Boxed equation" },
        { t({ "\\[ \\boxed{", "\t" }), i(1), t({ "", "}\\]" }) }
    ),

    s({ trig = "bn", name = "Boxed numbered equation" },
        { t({ "\\begin{equation} \\boxed{", "\t" }), i(1), t({ "", "} \\end{equation}" }) }
    ),
    
    --these require the tcolorbox package
    s({ trig = "rbox", name = "Red box" },
        { t({ "\\begin{tcolorbox}[colback=red!5!white,colframe=red!75!black]", "\t" }), i(1), t({ "", "\\end{tcolorbox}" }) }
    ),

    s({ trig = "gbox", name = "Green box" },
        { t({ "\\begin{tcolorbox}[colback=green!5!white,colframe=green!75!black]", "\t" }), i(1), t({ "", "\\end{tcolorbox}" }) }
    ),

    s({ trig = "bbox", name = "Blue box" },
        { t({ "\\begin{tcolorbox}[colback=blue!5!white,colframe=blue!75!black]", "\t" }), i(1), t({ "", "\\end{tcolorbox}" }) }
    ),

    s({ trig = "bigfun", name = "Big function" }, {
        t({ "\\begin{align*}", "\t" }),
        i(1),
        t(":"),
        t(" "),
        i(2),
        t("&\\longrightarrow "),
        i(3),
        t({ " \\", "\t" }),
        i(4),
        t("&\\longmapsto "),
        i(1),
        t("("),
        i(4),
        t(")"),
        t(" = "),
        i(0),
        t({ "", "\\end{align*}" }),
    }),
}
end

return M
