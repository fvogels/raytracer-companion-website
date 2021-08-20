set key off
set multiplot layout 2,1 rowsfirst
set samples 1000
set xtics 1
set ytics 1
set title "Quadratic in"
plot [0:1] x**2
set title "Quadratic out"
plot [0:1] 2*x - x**2
