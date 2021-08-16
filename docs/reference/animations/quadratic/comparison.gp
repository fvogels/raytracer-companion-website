set samples 1000
set ytics 0.5
set key outside
plot [0:1] x**2 title "in", \
           2*x-x**2 title "out", \
           x <= 0.5 ? (2*x**2) : (-2*x**2 + 4*x - 1) title "in/out"
