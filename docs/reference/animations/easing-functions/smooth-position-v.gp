set key off
set multiplot layout 1,2 rowsfirst
set samples 1000
set xtics 1
set ytics 1
set yrange [-3:3]
set xlabel "time"
set title "Sphere's X-Speed"
plot [0:4] x < 1 ? 2 : x < 2 ? 0 : x < 3 ? -2 : 0
set title "Sphere's Y-Speed"
plot [0:4] x < 1 ? 0 : x < 2 ? -2 : x < 3 ? 0 : 2
