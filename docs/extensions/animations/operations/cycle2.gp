set key off
set samples 1000
set xtics 2
set ytics 5
f(x) = x - 5 * sin(2 * x) / (1 + x)
plot [0:10] f(10-x)
