{smcl}
{p2col:{bf: gameoflife} {hline 2} Play Conway's Game of Life{p_end}}
{hline}

{marker syntax}{...}
{title:Syntax}

{cmd:gameoflife}, {ul:t}ime(#) {ul:d}imensions(#) {ul:v}isualize(plot|twoway) [twoway_options | plot_options]

{marker description}{...}
{title:Description}

{cmd:gameoflife} Conway's Game of Life is a cellular automaton devised by John Conway in 1970, in which cells on an infinite grid interact with neighbors, following a set of rules which determine whether a cell dies, lives on to the next generation, or is brought to life:

1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

This program implements the game in Stata with a randomized initial configuration, and visualizes the results. One key difference to the original game is the use of a grid with wraparound borders instead of an infinite grid (such that a cell at the top of the grid has its three upper neighbors at the bottom of the grid, and a cell at the rightmost edge has its three rightward neighbors at the leftmost edge).

{marker options}{...}
{title:Options}

{opt time} specifies the number of generations

{opt dimensions} specifies the dimensions of the universe

{opt visualize} specifies how the simulation should be visualized, using plot (faster, but less visually appealing) or a twoway scatter plot (slower, but more visually appealing)

{opt twoway_options} or {opt plot_options} specify further options for either plot or twoway

{hline}

{marker author}{...}
{title:Author}

Ali Atia
Email: alitarekatia@gmail.com
