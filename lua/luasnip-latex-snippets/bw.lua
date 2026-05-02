local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- ─── helper ───────────────────────────────────────────────────────────────────
local function tikzenv(body_snippet)
  -- wraps content in \begin{tikzpicture}...\end{tikzpicture}
  return body_snippet
end


return {

  -- ══════════════════════════════════════════════════════════════════════════
  -- 1. TABULAR
  -- ══════════════════════════════════════════════════════════════════════════

  -- Basic tabular
  s("tab", fmt([[
  \begin{{tabular}}{{{}}}
  \hline
  {} \\
  \hline
  {} \\
  \hline
  \end{{tabular}}]], {
  i(1, "c c c"),
  i(2, " &  & "),
  i(3, " &  & "),
})),

-- Booktabs-style table (preferred in academic papers)
s("tabb", fmt([[
\begin{{table}}[{}]
\centering
\caption{{{}}}
\label{{tab:{}}}
\begin{{tabular}}{{{}}}
\toprule
{} \\
\midrule
{} \\
\bottomrule
\end{{tabular}}
\end{{table}}]], {
i(1, "htbp"),
i(2, "Caption here"),
i(3, "label"),
i(4, "l c c"),
i(5, "Header1 & Header2 & Header3"),
i(6, "val1 & val2 & val3"),
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 2. TIKZ WRAPPERS
 -- ══════════════════════════════════════════════════════════════════════════

 -- Bare tikzpicture
 s("tikz", fmt([[
 \begin{{tikzpicture}}[{}]
 {}
 \end{{tikzpicture}}]], {
 i(1, "scale=1"),
 i(2, "% drawing here"),
 })),

 -- tikzpicture inside a figure float
 s("tikzfig", fmt([[
 \begin{{figure}}[{}]
 \centering
 \begin{{tikzpicture}}[{}]
 {}
 \end{{tikzpicture}}
 \caption{{{}}}
 \label{{fig:{}}}
 \end{{figure}}]], {
 i(1, "htbp"),
 i(2, "scale=1"),
 i(3, "% drawing here"),
 i(4, "Caption"),
 i(5, "label"),
 })),

 -- ══════════════════════════════════════════════════════════════════════════
 -- 3. AXES / GRAPHS (pgfplots + raw TikZ)
 -- ══════════════════════════════════════════════════════════════════════════

 -- pgfplots axis
 s("pgfaxis", fmt([[
 \begin{{tikzpicture}}
 \begin{{axis}}[
 xlabel={{{}}},
 ylabel={{{}}},
 xmin={}, xmax={},
 ymin={}, ymax={},
 grid=both,
 minor tick num=1,
 title={{{}}},
 ]
 \addplot[{}] {{{}}};
 \end{{axis}}
 \end{{tikzpicture}}]], {
 i(1, "$x$"),
 i(2, "$y$"),
 i(3, "0"), i(4, "10"),
 i(5, "0"), i(6, "1"),
 i(7, "Plot Title"),
 i(8, "blue, thick"),
 i(9, "sin(deg(x))"),
 })),

 -- Raw TikZ axes with arrows
 s("tikzaxes", fmt([[
 \begin{{tikzpicture}}
 % axes
 \draw[->] ({},0) -- ({},0) node[right] {{{}}};
 \draw[->] (0,{}) -- (0,{}) node[above] {{{}}};
 % origin label
 \node[below left] at (0,0) {{$O$}};
 {}
 \end{{tikzpicture}}]], {
 i(1, "-0.3"), i(2, "5"), i(3, "$x$"),
 i(4, "-0.3"), i(5, "4"), i(6, "$y$"),
 i(7, "% curves / points here"),
 })),

 -- Function plot (raw TikZ \draw plot)
 s("tikzplot", fmt([[
 \begin{{tikzpicture}}
 \draw[->] (-0.3,0) -- (6.5,0) node[right] {{{}}};
 \draw[->] (0,-1.3) -- (0,1.3) node[above] {{{}}};
 \draw[{}, domain={}, samples={}]
 plot (\x, {{{}}});
 \end{{tikzpicture}}]], {
 i(1, "$x$"),
 i(2, "$y$"),
 i(3, "blue, thick"),
 i(4, "0:6.28"),
 i(5, "100"),
 i(6, "sin(\\x r)"), -- \x r = \x in radians
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 4. VECTORS & FREE-BODY DIAGRAMS
 -- ══════════════════════════════════════════════════════════════════════════

 -- Single labelled arrow (vector)
 s("tikzvec", fmt([[
 \draw[->, thick, {}] ({}) -- ({}) node[midway, {}] {{{}}};]], {
   i(1, "blue"),
   i(2, "0,0"),
   i(3, "2,1"),
   i(4, "above"),
   i(5, "$\\vec{F}$"),
 })),

 -- Free-body diagram (block on surface)
 s("tikzfbd", fmt([[
 \begin{{tikzpicture}}[scale=1]
 % surface
 \draw[thick] (-1.5,0) -- (1.5,0);
 \fill[pattern=north east lines] (-1.5,-0.15) rectangle (1.5,0);
 % block
 \draw[thick, fill=gray!20] (-0.5,0) rectangle (0.5,1);
 \node at (0,0.5) {{{}}};
 % forces
 \draw[->, thick, red] (0,1) -- (0,2.2) node[right] {{$N$}}; % normal (up)
 \draw[->, thick, blue] (0,0.5) -- (0,-0.7) node[right] {{$mg$}}; % weight (down) 
 \draw[->, thick, green!60!black] (0.5,0.5) -- (1.7,0.5) node[above] {{$F$}}; % applied
 \draw[->, thick, orange] (-0.5,0.5) -- (-1.5,0.5) node[above] {{$f$}}; % friction
 \end{{tikzpicture}}]], {
 i(1, "$m$"),
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 5. SPRINGS & OSCILLATORS
 -- ══════════════════════════════════════════════════════════════════════════

 -- Horizontal spring-mass (uses decorations.pathmorphing)
 s("tikzspring", fmt([[
 \usetikzlibrary{{decorations.pathmorphing}}
 \begin{{tikzpicture}}
 % wall
 \fill[pattern=north east lines] (-0.2,-0.5) rectangle (0,0.5);
 \draw[thick] (0,-0.5) -- (0,0.5);
 % spring
 \draw[decoration={{coil, aspect=0.4, segment length=4pt, amplitude=5pt}},
 decorate, thick] (0,0) -- ({},0);
 % mass
 \draw[fill=gray!30, thick] ({}, -0.4) rectangle ({}, 0.4)
 node[midway] {{{}}};
 % equilibrium dashed line
 \draw[dashed] ({}, -0.7) -- ({}, 0.7) node[above] {{$x_0$}};
 \end{{tikzpicture}}]], {
 i(1, "3"), -- spring end x
 i(2, "3"), -- mass left edge
 i(3, "4"), -- mass right edge
 i(4, "$m$"),
 i(5, "3.5"), -- equilibrium x (left)
 i(6, "3.5"), -- equilibrium x (right)
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 6. PENDULUM
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzpend", fmt([[
 \begin{{tikzpicture}}
 % pivot
 \fill (0,0) circle (2pt);
 \draw[thick] (-0.5,0) -- (0.5,0);
 \fill[pattern=north east lines] (-0.5,0) rectangle (0.5,0.15);
 % rod
 \draw[thick] (0,0) -- ({},{}) coordinate (bob);
 % bob
 \fill[gray!40] (bob) circle ({}pt);
 \draw[thick] (bob) circle ({}pt);
 % angle arc
 \draw[->] (0,-0.8) arc[start angle=-90, end angle={}, radius=0.8]
 node[midway, right] {{$\theta$}};
 % gravity
 \draw[->, thick, blue] (bob) -- ++(0,-1) node[right] {{$mg$}};
 \end{{tikzpicture}}]], {
 i(1, "1.5"), -- bob x
 i(2, "-2.6"), -- bob y
 i(3, "8"), -- bob radius pt
 i(4, "8"),
 i(5, "-70"), -- angle end
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 7. ENERGY LEVEL DIAGRAM
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzenergy", fmt([[
 \begin{{tikzpicture}}[xscale=1, yscale=0.6]
 % energy levels (horizontal lines)
 \draw[thick] (0,0) -- (2,0) node[right] {{$E_1$}};
 \draw[thick] (0,2) -- (2,2) node[right] {{$E_2$}};
 \draw[thick] (0,5) -- (2,5) node[right] {{$E_3$}};
 \draw[thick] (0,9) -- (2,9) node[right] {{$E_4 = 0$ (ionisation)}};
 % transition arrow
 \draw[->, red, thick] (1,2) -- (1,5)
 node[midway, right] {{$h\nu$}};
 % ground label
 \node[left] at (0,0) {{Ground}};
 % axis label
 \draw[->] (-0.5,-0.5) -- (-0.5,10) node[above] {{$E$}};
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 8. CIRCUIT (circuitikz) – requires \usepackage{circuitikz}
 -- ══════════════════════════════════════════════════════════════════════════

 -- Simple RC circuit
 s("tikzrc", fmt([[
 \begin{{circuitikz}}[american]
 \draw (0,0)
 to[battery1, l={{{}}}, v_={}V] (0,3)
 to[R, l={{{}}}, -] (3,3)
 to[C, l={{{}}}, -] (3,0)
 -- (0,0);
 \end{{circuitikz}}]], {
 i(1, "$\\mathcal{E}$"),
 i(2, "12"),
 i(3, "$R$"),
 i(4, "$C$"),
 })),

 -- Simple RLC series loop
 s("tikzrlc", fmt([[
 \begin{{circuitikz}}[american]
 \draw (0,0)
 to[battery1, l={{{}}}, v_={{{}}V}] (0,3)
 to[R, l={{{}}}, -] (2,3)
 to[L, l={{{}}}, -] (4,3)
 to[C, l={{{}}}, -] (4,0)
 -- (0,0);
 \end{{circuitikz}}]], {
 i(1, "$V_s$"),
 i(2, "12"),
 i(3, "$R$"),
 i(4, "$L$"),
 i(5, "$C$"),
 })),

 -- Op-amp inverting amplifier
 s("tikzopamp", fmt([[
 \begin{{circuitikz}}[american, scale=0.9]
 \node[op amp] (opamp) at (3,0) {{{}}};
 \draw (opamp.-) to[R, l=$R_1$, -o] ++(-2,0) node[left] {{$V_{{in}}$}};
 \draw (opamp.-) to[R, l=$R_f$] ++(0,1.5) -| (opamp.out);
 \draw (opamp.+) -- ++(-0.5,0) node[ground] {{}};
 \draw (opamp.out) to[short, -o] ++(0.5,0) node[right] {{$V_{{out}}$}};
 \end{{circuitikz}}]], {
 i(1, ""),
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 9. WAVE DIAGRAM
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzwave", fmt([[
 \begin{{tikzpicture}}
 \draw[->] (-0.3,0) -- (7,0) node[right] {{$x$}};
 \draw[->] (0,-1.5) -- (0,1.7) node[above] {{$\psi$}};
 % wave
 \draw[blue, thick, domain=0:6.6, samples=200]
 plot(\x, {{{}*sin({}*\x r + {})}});
 % amplitude label
 \draw[<->, red, dashed] (1.57, 0) -- (1.57, {}) node[midway, right] {{$A$}};
 % wavelength label
 \draw[<->, green!60!black] (0,-1.3) -- (6.28,-1.3) node[midway, below] {{$\lambda$}};
 \end{{tikzpicture}}]], {
 i(1, "1"), -- amplitude
 i(2, "1"), -- k (wavenumber, in plot \x is already in rad via 'r')
 i(3, "0"), -- phase
 i(4, "1"), -- amplitude for arrow
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 10. ELECTRIC FIELD LINES (parallel plates)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzefield", fmt([[
 \begin{{tikzpicture}}
 % plates
 \draw[very thick] (0,-2) -- (0, 2);
 \draw[very thick] (4,-2) -- (4, 2);
 \node[left] at (0,0) {{$+$}};
 \node[right] at (4,0) {{$-$}};
 % field lines
 \foreach \y in {{-1.5,-0.75,0,0.75,1.5}} {{
   \draw[->, blue, thick] (0,\y) -- (4,\y);
 }}
 % label
 \node[above] at (2,2) {{$\vec{E}$}};
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 11. MAGNETIC FIELD (into / out of page symbols)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzbfield", fmt([[
 \begin{{tikzpicture}}
 % grid of field symbols (out of page = dot, into page = cross)
 \foreach \x in {{0,1,2,3}} {{
   \foreach \y in {{0,1,2}} {{
     % out of page: \fill then \draw dot
     \fill ({{\x}},{{\y}}) circle (2pt);
   }}
 }}
 \node[above right] at (3,2) {{$\vec{B}$ (out of page)}};
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 12. COORDINATE SYSTEMS
 -- ══════════════════════════════════════════════════════════════════════════

 -- 2D polar coords
 s("tikzpolar", fmt([[
 \begin{{tikzpicture}}
 % axes
 \draw[->] (-0.3,0) -- (3.5,0) node[right] {{$x$}};
 \draw[->] (0,-0.3) -- (0,3.5) node[above] {{$y$}};
 % point P
 \coordinate (P) at ({},{});
 \fill (P) circle (2pt) node[above right] {{$P(r,\theta)$}};
 % radius vector
 \draw[->, thick, blue] (0,0) -- (P) node[midway, above left] {{$r$}};
 % angle arc
 \draw (0.8,0) arc[start angle=0, end angle={}, radius=0.8]
 node[midway, right] {{$\theta$}};
 % dashed projections
 \draw[dashed] (P) -- ({},0) node[below] {{$x$}};
 \draw[dashed] (P) -- (0,{}) node[left] {{$y$}};
 \end{{tikzpicture}}]], {
 i(1, "2.5"), -- Px
 i(2, "2"), -- Py
 i(3, "38"), -- angle deg
 i(4, "2.5"), -- Px again for projection
 i(5, "2"), -- Py again for projection
 })),

 -- 3D axes (isometric-style with tikz-3dplot or manual)
 s("tikz3d", fmt([[
 \begin{{tikzpicture}}[x=(1cm,0cm), y=(0.4cm,0.3cm), z=(0cm,1cm)]
 % axes
 \draw[->] (0,0,0) -- ({},0,0) node[right] {{$x$}};
 \draw[->] (0,0,0) -- (0,{},0) node[below right] {{$y$}};
 \draw[->] (0,0,0) -- (0,0,{}) node[above] {{$z$}};
 {}
 \end{{tikzpicture}}]], {
 i(1, "4"), i(2, "4"), i(3, "4"),
 i(4, "% draw 3-D objects here"),
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 13. FEYNMAN-STYLE DIAGRAMS (manual TikZ, no tikz-feynman pkg required)
 -- ══════════════════════════════════════════════════════════════════════════

 -- QED vertex e⁻ + e⁻ → e⁻ + e⁻ (t-channel photon)
 s("tikzfeynman", fmt([[
 \begin{{tikzpicture}}[scale=1.2]
 % incoming electrons
 \draw[->-={0.6}, thick] (-1.5, 1) -- (0, 0.5) node[left, pos=0] {{$e^-$}};
 \draw[->-={0.6}, thick] (-1.5,-1) -- (0,-0.5) node[left, pos=0] {{$e^-$}};
 % vertices
 \fill (0, 0.5) circle (2.5pt);
 \fill (0,-0.5) circle (2.5pt);
 % internal photon (wavy)
 \draw[decorate, decoration={{snake, amplitude=2pt, segment length=6pt}}, thick]
 (0,0.5) -- (0,-0.5) node[midway, right] {{$\gamma$}};
 % outgoing electrons
 \draw[->-={0.6}, thick] (0, 0.5) -- (1.5, 1) node[right] {{$e^-$}};
 \draw[->-={0.6}, thick] (0,-0.5) -- (1.5,-1) node[right] {{$e^-$}};
 \end{{tikzpicture}}
 % NOTE: ->- style requires \usetikzlibrary{decorations.markings}
 % and \tikzset{->-/.style={decoration={markings,
 % mark=at position #1 with {\arrow{>}}}, postaction={decorate}}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 14. PHASE PORTRAIT (simple harmonic oscillator)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzphase", fmt([[
 \begin{{tikzpicture}}
 \draw[->] (-2.5,0) -- (2.5,0) node[right] {{$x$}};
 \draw[->] (0,-2.5) -- (0,2.5) node[above] {{$\dot x$}};
 % elliptical orbits for SHO
 \foreach \r in {{0.5, 1.0, 1.5, 2.0}} {{
   \draw[blue, thick] (0,0) ellipse ({{\r}} and {{\r}});
 }}
 \node[below right] at (2,0) {{stable};
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 15. POTENTIAL WELL (infinite square well / particle in a box)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzwell", fmt([[
 \begin{{tikzpicture}}[yscale=0.5]
 \def\L{{4}} % well width
 % walls (infinite)
 \draw[very thick] (0,-0.5) -- (0,8) -- (-0.4,8);
 \draw[very thick] (\L,-0.5) -- (\L,8) -- (\L+0.4,8);
 % floor
 \draw[very thick] (0,-0.5) -- (\L,-0.5);
 % energy levels E_n ∝ n²
 \foreach \n in {{1,2,3}} {{
   \pgfmathsetmacro{{\En}}{{{\n}*{\n}}}
   \draw[dashed, gray] (0,\En) -- (\L,\En)
   node[right, black] {{$E_{{\n}}$}};
   % wavefunction sketch
   \draw[blue, thick, domain=0:\L, samples=80]
   plot(\x, {{\En + 0.8*sin({\n}*pi*\x/\L r)}});
 }}
 % axis
 \draw[->] (-0.5,-0.5) -- (-0.5,9) node[above] {{$E$}};
 \draw[->] (0,-1) -- (\L,-1) node[right] {{$x$}};
 \node[below] at (0,-1) {{$0$}};
 \node[below] at (\L,-1) {{$L$}};
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 16. BLOCH SPHERE (quantum computing / NMR)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzbloch", fmt([[
 \begin{{tikzpicture}}[scale=2]
 % sphere outline
 \draw[thick] (0,0) circle (1);
 \draw[dashed] (0,0) ellipse (1 and 0.3); % equator (dashed behind)
 % axes
 \draw[->] (0,0) -- (0, 1.3) node[above] {{$|0\rangle$}};
 \draw[->] (0,0) -- (0,-1.3) node[below] {{$|1\rangle$}};
 \draw[->] (0,0) -- (1.2, 0) node[right] {{$y$}};
 \draw[->] (0,0) -- (-0.6,-0.4) node[left] {{$x$}};
 % state vector
 \draw[->, thick, red] (0,0) -- (0.5, 0.3, 0.8)
 node[above right] {{$|\psi\rangle$}};
 % angles
 \node at (0.1, 0.55) {{$\theta$}};
 \node at (0.3, 0.05) {{$\phi$}};
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 17. VECTOR FIELD (2D arrows on a grid)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzvfield", fmt([[
 \begin{{tikzpicture}}[scale=0.7]
 \draw[->] (-3.2,0) -- (3.2,0) node[right] {{$x$}};
 \draw[->] (0,-3.2) -- (0,3.2) node[above] {{$y$}};
 \foreach \x in {{-3,-2,-1,0,1,2,3}} {{
   \foreach \y in {{-3,-2,-1,0,1,2,3}} {{
     % field: F = (-y, x) (circular field)
     \pgfmathsetmacro{{\vx}}{{-\y}}
     \pgfmathsetmacro{{\vy}}{{\x}}
     \pgfmathsetmacro{{\len}}{{sqrt(\vx*\vx + \vy*\vy)}}
     \pgfmathsetmacro{{\scale}}{{0.35}}
     \ifdim\len pt>0.01pt
     \draw[->, blue!70]
     (\x,\y) -- ({\x + \scale*\vx/\len}, {\y + \scale*\vy/\len});
     \fi
   }}
 }}
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 18. SPACETIME DIAGRAM (Minkowski)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzminkowski", fmt([[
 \begin{{tikzpicture}}[scale=1.1]
 % axes
 \draw[->] (-2.5,0) -- (2.5,0) node[right] {{$x$}};
 \draw[->] (0,-0.3) -- (0,3) node[above] {{$ct$}};
 % light cone
 \draw[red, thick, dashed] (-2.5,2.5) -- (0,0) -- (2.5,2.5)
 node[right] {{light cone}};
 % worldline example
 \draw[blue, very thick] (-1,0) .. controls (-0.5,1) .. (0,2.5)
 node[right] {{worldline}};
 % simultaneity line (tilted frame)
 \draw[green!60!black, thick, dashed] (-2,1) -- (2,1)
 node[right] {{$t = \text{const}$}};
 % event
 \fill (0.5,1.5) circle (2pt) node[right] {{event}};
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 19. COMMUTATIVE DIAGRAM (category theory / math)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzcommute", fmt([[
 % Requires: \usetikzlibrary{cd} (tikz-cd package)
 \begin{{tikzcd}}
 {} \arrow[r, "{}"] \arrow[d, "{}"'] &
 {} \arrow[d, "{}"] \\
 {} \arrow[r, "{}"'] &
 {}
 \end{{tikzcd}}]], {
 i(1, "A"), i(2, "f"), i(3, "g"),
 i(4, "B"), i(5, "h"),
 i(6, "C"), i(7, "k"),
 i(8, "D"),
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 20. GAUSSIAN BELL CURVE / probability density
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzgauss", fmt([[
 \begin{{tikzpicture}}
 \draw[->] (-3.5,0) -- (3.5,0) node[right] {{$x$}};
 \draw[->] (0,-0.1) -- (0,1.3) node[above] {{$P(x)$}};
 % Gaussian: A exp(-x²/(2σ²))
 \draw[blue, thick, domain=-3.2:3.2, samples=120]
 plot(\x, {{{}*exp(-(\x)^2 / (2*{}^2))}});
 % sigma markers
 \draw[dashed, red] ({}, 0) -- ({}, 0.6) node[above] {{$\mu+\sigma$}};
 \draw[dashed, red] (-{},0) -- (-{},0.6) node[above] {{$\mu-\sigma$}};
 \node[below] at (0,0) {{$\mu$}};
 \end{{tikzpicture}}]], {
 i(1, "1"), -- amplitude
 i(2, "1"), -- sigma in exponent
 i(3, "1"), -- +sigma x coord
 i(4, "1"), -- y at sigma
 i(5, "1"), -- sigma for left marker
 i(6, "1"),
 })),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 21. BLOCK DIAGRAM (control systems / signal flow)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzblock", fmt([[
 \begin{{tikzpicture}}[
 block/.style = {draw, thick, rectangle, minimum width=2cm, minimum height=1cm, align=center},
 sum/.style = {draw, thick, circle, minimum size=0.6cm},
 >=latex
 ]
 % input
 \node[left] (in) at (0,0) {{$R(s)$}};
 % summing junction
 \node[sum] (sum) at (1.5,0) {{$\Sigma$}};
 % plant
 \node[block] (plant) at (4,0) {{$G(s)$}};
 % output
 \node[right] (out) at (6.5,0) {{$Y(s)$}};
 % feedback
 \node[block] (fb) at (4,-1.8) {{$H(s)$}};
 % connections
 \draw[->] (in) -- (sum);
 \draw[->] (sum) -- (plant);
 \draw[->] (plant) -- (out);
 % feedback path
 \draw[->] (5.5,0) |- (fb);
 \draw[->] (fb) -| (sum) node[pos=0.95, right] {{$-$}};
 \end{{tikzpicture}}]], {})),


 -- ══════════════════════════════════════════════════════════════════════════
 -- 22. THERMODYNAMIC CYCLE (PV diagram – Carnot)
 -- ══════════════════════════════════════════════════════════════════════════

 s("tikzcarnot", fmt([[
 \begin{{tikzpicture}}[scale=1]
 \draw[->] (0,0) -- (5,0) node[right] {{$V$}};
 \draw[->] (0,0) -- (0,4) node[above] {{$P$}};
 % isothermal expansion (A→B): PV = const ⇒ P = C/V
 \draw[blue, thick, domain=0.8:2.5, samples=80]
 plot(\x, {{2/\x}}) node[above right] {{$T_H$}};
 % adiabatic expansion (B→C): PV^γ = const ≈ P ~ V^{-γ}
 \draw[green!60!black, thick, domain=2.5:4, samples=80]
 plot(\x, {{60/(\x)^2.5}});
 % isothermal compression (C→D)
 \draw[red, thick, domain=1.2:4, samples=80]
 plot(\x, {{0.6/\x}}) node[below right] {{$T_C$}};
 % adiabatic compression (D→A)
 \draw[orange, thick, domain=0.8:1.2, samples=80]
 plot(\x, {{0.6/\x^2.5 * 0.8^1.5}});
 % labels
 \node[above left] at (0.8, 2.5) {{$A$}};
 \node[above right] at (2.5,0.8) {{$B$}};
 \node[below right] at (4,0.15) {{$C$}};
 \node[below left] at (1.2,0.5) {{$D$}};
 \node at (2.5,1.5) {{Carnot}};
 \end{{tikzpicture}}]], {})),

} -- end return
