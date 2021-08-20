set key off
set multiplot layout 1,2 rowsfirst
set samples 1000
set xtics 1
set ytics 1
set xrange [0:4]
set yrange [-5:5]
set xlabel "time"
set title "Sphere's X-Speed"
plot [0:4] x < 0.5 ? 8 * x : \
           x < 1 ? 4 - 8 * (x - 0.5) : \
           x < 2 ? 0 : \
           x < 2.5 ? -8 * (x - 2) : \
           x < 3 ? -4 + 8 * (x - 2.5) : \
           0
set title "Sphere's Y-Speed"
plot [0:4] x < 1 ? 0 : \
           x < 1.5 ? -8 * (x - 1) : \
           x < 2 ? -4 + 8 * (x - 1.5) : \
           x < 3 ? 0 : \
           x < 3.5 ? 8 * (x - 3) : \
           4 - 8 * (x - 3.5)
