set key off
set samples 1000
set ytics 1
set multiplot layout 4,1 rowsfirst
plot [0:10] 1 - cos(5 * pi * x) / (exp(0.0 * x))
plot [0:10] 1 - cos(5 * pi * x) / (exp(0.2 * x))
plot [0:10] 1 - cos(5 * pi * x) / (exp(0.4 * x))
plot [0:10] 1 - cos(5 * pi * x) / (exp(0.6 * x))
