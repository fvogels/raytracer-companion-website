set key off
set samples 1000
set ytics 1
set multiplot layout 4,1 rowsfirst
plot [0:10] 1 - cos(x)
plot [0:10] 1 - cos(2*x)
plot [0:10] 1 - cos(3*x)
plot [0:10] 1 - cos(4*x)