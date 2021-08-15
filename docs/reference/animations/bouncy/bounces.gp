set key off
set samples 1000
set multiplot layout 3,1 rowsfirst
set ytics 0.5
plot [0:1] 1 - abs(cos(x*3*1.5*pi) / (2**(3*x)))
plot [0:1] 1 - abs(cos(x*5*1.5*pi) / (2**(3*x)))
plot [0:1] 1 - abs(cos(x*11*1.5*pi) / (2**(3*x)))
