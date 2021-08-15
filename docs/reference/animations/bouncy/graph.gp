set key off
set samples 1000
plot [0:1] 1 - abs(cos(x*5*1.5*pi) / (2**(3*x)))