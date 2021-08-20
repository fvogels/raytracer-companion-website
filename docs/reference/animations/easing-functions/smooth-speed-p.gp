set key off
set multiplot layout 1,2 rowsfirst
set samples 1000
set xtics 1
set ytics 1
set xrange [0:4]
set yrange [-5:5]
set xlabel "time"
set title "Sphere's X-Position"
plot [0:4] x < 0.5 ? 4 * x**2 : \
           x < 1 ? -2 + 8*x - 4*x**2 : \
           x < 2 ? 2 : \
           x < 2.5 ? -2 * (7-8*x+2*x**2) : \
           x < 3 ? 4 * (x-3)**2 : \
           0
set title "Sphere's Y-Position"
plot [0:4] x < 1 ? 0 : \
           x < 1.5 ? -4 * (x-1)**2 : \
           x < 2 ? 2 * (7 - 8 * x + 2 * x**2) : \
           x < 3 ? -2 : \
           x < 3.5 ? 34-24*x+4*x**2 : \
           -4*(x-4)**2
