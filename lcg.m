function output = lcg(x, c, m, a)
    output = mod(mod(c * x + a, m), 100) + 1;