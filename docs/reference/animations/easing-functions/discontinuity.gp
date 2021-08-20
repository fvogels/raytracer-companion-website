set key off
set samples 1000
set multiplot layout 3,1 rowsfirst
set xtics 0.25
set ytics 1
set yrange [-2:2]
plot [0:1] x < 0.25 ? -1 : x < 0.75 ? 1 : -1
