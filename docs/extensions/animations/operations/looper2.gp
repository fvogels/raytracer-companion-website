set key off
set samples 1000
set xtics 10
set ytics 5
f(x) = x < 10 ? x - 5 * sin(2 * x) / (1 + x) : f(x - 10)
plot [0:50] f(x)