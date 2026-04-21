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
-- templates 
--
-- notes
s({ trig = "notes", name = "Notes template" },
  { t({ 
    "\\documentclass[twoside]{article}",                    "\t", "\t",
    "\\usepackage{adapreamble}",                            "\t",
    "\\geometry{",                                          "\t",
    "inner=1.5in,",                                         "\t",
    "outer=1.5in,",                                         "\t", 
    "top=1in,",                                             "\t",
    "bottom=1in,",                                          "\t",
    "}",                                                    "\t",
    "\\usepackage{adaenvs}",                                "\t",
    "\\usepackage{adanotes}",                               "\t",
    "% Author and class info",                              "\t", "\t",
    "\\newcommand{\\notesTitle}{", }),       i(1), t({ "}", "\t",
    "\\newcommand{\\notesDate}{", }),        i(2), t({ "}", "\t",
    "\\newcommand{\\courseName}{", }),       i(3), t({ "}", "\t",
    "\\newcommand{\\courseCode}{", }),       i(4), t({ "}", "\t", 
    "\\newcommand{\\courseInstructor}{", }), i(5), t({ "}", "\t",        
    "\\newcommand{\\authorName}{", }),       i(6), t({ "}", "\t", "\t",
    "\\begin{document}",                                    "\t", "\t",
    "\\maketitle",                                          "\t", "\t",
    "\\newpage",                                            "\t", "\t"
  }) }  
),
-- homework
s({ trig = "asgmt", name = "Assignment template" },
  { t({ 
    "\\documentclass[twoside]{article}",                     "\t", "\t",
    "\\usepackage{adapreamble}",                             "\t",
    "\\geometry{",                                           "\t",
    "inner=1.75in,",                                         "\t",
    "outer=1.75in,",                                         "\t", 
    "top=1in,",                                              "\t",
    "bottom=1in,",                                           "\t",
    "}",                                                     "\t",
    "\\usepackage{adaenvs}",                                 "\t",
    "\\usepackage{adaassignment}",                           "\t",
    "% Author and class info",                               "\t", "\t",
    "\\newcommand{\\assignmentTitle}{", }),   i(1), t({ "}", "\t",
    "\\newcommand{\\assignmentDueDate}{", }), i(2), t({ "}", "\t",
    "\\newcommand{\\courseName}{", }),        i(3), t({ "}", "\t",
    "\\newcommand{\\courseCode}{", }),        i(4), t({ "}", "\t", 
    "\\newcommand{\\courseInstructor}{", }),  i(5), t({ "}", "\t",        
    "\\newcommand{\\authorName}{", }),        i(6), t({ "}", "\t", "\t" 
    "\\begin{document}",                                     "\t", "\t",
    "\\maketitle",                                           "\t", "\t",
    "\\newpage",                                             "\t", "\t" 
  }) }
),
    -- unnumbered sections use custom unnumbered section command
    s({ trig = "sct", name = "Unnumbered section" },
    { t({ "\\sectionU{" }), i(1), t({ "}" }) }
  ),

  s({ trig = "bct", name = "Unnumbered subsection" },
  { t({ "\\subsectionU{" }), i(1), t({ "}" }) }
),

s({ trig = "cct", name = "Unnumbered subsubsection" },
{ t({ "\\subsubsectionU{" }), i(1), t({ "}" }) }
 ),

 s({ trig = "Sct", name = "Numbered section" },
 { t({ "\\section{" }), i(1), t({ "}" }) }
 ),

 s({ trig = "Bct", name = "Numbered subsection" },
 { t({ "\\subsection{" }), i(1), t({ "}" }) }
),

s({ trig = "Cct", name = "Numbered subsubsection" },
{ t({ "\\subsubsection{" }), i(1), t({ "}" }) }
 ),

 s({ trig = "beq", name = "Numbered equation" },
 { t({ "\\begin{equation}", "\t" }), i(1), t({ "", "\\end{equation}" }) }
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

-- custom tcolorbox 
s({ trig = "box", name = "Box" },
{ t({ "\\begin{box}", "\t" }), i(1), t({ "", "\\end{box}" }) }
),

s({ trig = "examp", name = "Example" },
{ t({ "\\begin{example}[" }), i(1), t({ "]", "\t" }), i(2), t({ "", "\\end{example}" }) }
),

s({ trig = "def", name = "Definition" },
{ t({ "\\begin{definition}[" }), i(1), t({ "]", "\t" }), i(2), t({ "", "\\end{definition}" }) }
),


s({ trig = "rmrk", name = "Remark" },
{ t({ "\\begin{remark}[" }), i(1), t({ "]", "\t" }), i(2), t({ "", "\\end{remark}" }) }
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
