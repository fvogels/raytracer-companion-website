set key off
set samples 1000
set xtics 1
set ytics 1
plot [0:1] x, x**2, x**3, 2*x-x**2, x**3-3*x**2+3*x, 1 - cos(3.25 * 2 * pi * x) / (4 * x + 1)
