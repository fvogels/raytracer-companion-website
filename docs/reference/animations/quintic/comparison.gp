set samples 1000
set ytics 0.5
set key outside
plot [0:1] x**5 title "in", \
           1 - (1-x)**5 title "out", \
           x <= 0.5 ? (16*x**5) : (1-(-2*x+2)**5 / 2) title "in/out"
