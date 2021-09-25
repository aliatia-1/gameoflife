# gameoflife
Conway's Game of Life is a cellular automaton devised by John Conway in 1970, in which cells on an infinite grid interact with neighbors, following a set of rules which determine whether a cell dies, lives on to the next generation, or is brought to life:

1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

This program implements the game in Stata with a randomized initial configuration, and visualizes the results. One key difference to the original game is the use of a grid with wraparound borders instead of an infinite grid (such that a cell at the top of the grid has its three upper neighbors at the bottom of the grid, and a cell at the rightmost edge has its three rightward neighbors at the leftmost edge).

To install, type:

net install gameoflife, from("https://raw.githubusercontent.com/aliatia-1/gameoflife/main/")
