# About
This is a repo to store the code that was used to explore Homotopy Continuation and its applications to Economics. This is done as part of the seminar course at the University of Hawaii at Manoa under Max Hill. 

The following is the type of problems that are considered, along with the examples that I have found or made up.
1. Bertrand Duopoly Model
2. Stackelberg Duopoly Model (extremely simple)

I had intentions of doing the rest of the examples, but they were dynamic stochastic games, which is a bit out of my league. 

## Structure
The tree with the most important stuff. Things aren't fully clean (yet), but the data I have gathered from HomotopyContinuation.jl are the csv files, the images folder contains the actual output from R, while figures is the adapted version for the poster.
```
.
├── bertrand_paths_full.csv
├── homotopy_paths.png
├── homotopy_test_traces.csv
├── images
│   ├── bertrand-plot.png
│   ├── bertrand-realprices.html
│   ├── test2-plot.png
│   ├── test2-realplot.png
│   ├── test2-trueplot.png
│   └── test2.html
├── path_summary.csv
├── poster
│   ├── figures
│   ├── logos
│   ├── phan-m480-poster.pdf
│   ├── poster.bib
│   ├── poster.pdf
│   ├── poster.tex
├── README.md
├── src
│   ├── bertrand-simple.jl
│   ├── duff-example.jl
│   ├── plots
│   │   ├── bertrand-simple.R
│   │   ├── stackelberg-plot.R
│   │   └── test2-plot.R
│   ├── stackelberg-simple.jl
│   ├── test.jl
│   └── test2.jl
├── stackelberg_paths_final.csv
└── writing
    ├── main.pdf
    ├── main.synctex.gz
    ├── main.tex
    └── sections
```


# Notes
Anything that is done in Bertini we can do in HomotopyContinuation.jl. However, it would have been good to consider some class or family of problems that we can explore further.
