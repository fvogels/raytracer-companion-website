set key off
set multiplot layout 1,2 rowsfirst
set samples 1000
set xtics 1
set ytics 1
set yrange [-2:2]
set xlabel "time"
set title "Sphere's X-Position"
plot [0:4] x < 1 ? -1 + 2 * x : x < 2 ? 1 : x < 3 ? 1 - 2 * (x - 2) : -1
set title "Sphere's Y-Position"
plot [0:4] x < 1 ? 1 : x < 2 ? 1 - 2 * (x - 1) : x < 3 ? -1 : -1 + 2 * (x - 3)
