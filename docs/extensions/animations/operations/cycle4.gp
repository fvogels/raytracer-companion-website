set key off
set samples 1000
set xtics 10
set ytics 5
f(x) = x - 5 * sin(2 * x) / (1 + x)
g(x) = f(10-x)
h(x) = x < 10 ? f(x) : g(x-10)
i(x) = x < 20 ? h(x) : i(x-20)
plot [0:100] i(x)
