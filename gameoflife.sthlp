{smcl}
{* *! version 1.0  7 Feb 2022}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "gameoflife##syntax"}{...}
{viewerjumpto "Description" "gameoflife##description"}{...}
{viewerjumpto "Options" "gameoflife##options"}{...}
{viewerjumpto "Remarks" "gameoflife##remarks"}{...}
{viewerjumpto "Examples" "gameoflife##examples"}{...}
{title:Title}
{phang}
{bf:gameoflife} {hline 2} gameoflife

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:gameoflife}
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}

{syntab:Required }

{synopt:{opt t:ime(#)}}  specifies the number of generations to process (e.g., 50). {p_end}

{synopt:{opt v:isualize(str)}}  specifies the mode of visualization from the available options plot, twoway, or none. {p_end}

{synopt:{opt d:imensions(#)}}  specifies the starting dimensions of the square grid, if randomly generated (e.g., 50). {p_end}
{synopt:{opt border(str)}}  specifies the behavior of the border. Specifying infinite causes the border to dynamically expand as cells move beyond the initially specified dimensions. Specifying wrap causes the border to wrap around toroidally such that cells which cross the top border move to the bottom (and vice-versa), and cells which cross the left border move to the right (and vice-versa). {p_end}

{syntab:Optional}
{synopt:{opt i:nput(str)}} optionally allows the input of a starting grid, previously generated using the export option.

{synopt:{opt e:xport(str)}} optionally allows the export of the randomly generated starting grid, as well as generated visualizations if twoway is specified within the visualization() option.

{synopt:{opt switchat(numlist max=1)}} optionally specifies the generation at which the visualization format should be switched to a format specified under switchto().

{synopt:{opt switchto(str)}} optionally specifies the format to which the visualization should should be switched at the generation specified by switchat().

{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd}

{pstd}
 {cmd:gameoflife} implements John Conway's Game of Life in Stata (https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

{marker options}{...}
{title:Options}
{dlgtab:Main}

{phang}
{opt t:ime(#)}  specifies the number of generations to process (e.g., 50).

{phang}
{opt v:isualize(str)}  specifies the mode of visualization from the available options plot, twoway, or none.

{phang}
{opt d:imensions(#)}  specifies the starting dimensions of the square grid, if randomly generated (e.g., 50).

{phang}
{opt border(str)}  specifies the behavior of the border.
Specifying infinite causes the border to dynamically expand as cells move beyond the initially specified dimensions.
Specifying wrap causes the border to wrap around toroidally such that cells which cross the top border move to the bottom (and vice-versa), and cells which cross the left border move to the right (and vice-versa).

{phang}
{opt i:nput(str)}  optionally allows the input of a starting grid, previously generated using the export option.

{phang}
{opt e:xport(str)}  optionally allows the export of the randomly generated starting grid, as well as generated visualizations if twoway is specified within the visualization() option.

{phang}
{opt switchat(numlist max=1)}  optionally specifies the generation at which the visualization format should be switched to a format specified under switchto().

{phang}
{opt switchto(str)}  optionally specifies the format to which the visualization should should be switched at the generation specified by switchat().



{marker examples}{...}
{title:Examples}

 {stata gameoflife, time(50) dimensions(50) border(infinite) visualize(twoway) export(test) name(test)}


{title:Author}
{p}

Ali Atia

Email {browse "mailto:alitarekatia@gmail.com":alitarekatia@gmail.com}
