set samples 1000
set ytics 0.5
set key outside
plot [0:1] x**3 title "in", \
           x**3 - 3*x**2 + 3*x title "out", \
           x <= 0.5 ? (4*x**3) : (4*x**3-12*x**2+12*x-3) title "in/out"
