set key off
set multiplot layout 1,2 rowsfirst
set samples 1000
set xtics 2
set ytics 5
set yrange [-5:20]
f(x) = x - 5 * sin(2 * x) / (1 + x)
g(x) = f(10) - x**3/50 - x**2/10 +2*x
h(x) = x < 10 ? f(x) : g(x-10)
plot [0:10] f(x)
plot [0:10] g(x)