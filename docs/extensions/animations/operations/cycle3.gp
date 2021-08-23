set key off
set samples 1000
set xtics 2
set ytics 5
f(x) = x - 5 * sin(2 * x) / (1 + x)
g(x) = f(10-x)
h(x) = x < 10 ? f(x) : g(x-10)
plot [0:20] h(x)
