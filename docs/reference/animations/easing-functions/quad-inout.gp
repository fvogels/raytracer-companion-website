set key off
set samples 1000
set xtics 1
set ytics 1
set title "Quadratic in/out"
plot [0:1] x < 0.5 ? 2 * x**2 : \
           -2 * x**2 + 4 * x - 1
