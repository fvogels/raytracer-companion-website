set key off
set samples 1000
set parametric
set xtics 1
set ytics 1
set ztics 1
set xrange [-2:2]
set yrange [-2:2]
set zrange [-2:2]
set size ratio 1
splot [t=0:1] sin(8*pi*t), 2*sin(4*pi*t-pi/2), sin(6*pi*t)
