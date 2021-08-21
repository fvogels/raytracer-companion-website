set key off
set samples 1000
set parametric
set xtics 1
set ytics 1
set xrange [-2:2]
set yrange [-2:2]
set size ratio 1
plot [t=0:1] 2*cos(2*pi*t), sin(8*pi*t)
