function output = lcg(x)
    output = mod(mod(1103515245 * x + 12345, 2^31), 100) + 1;