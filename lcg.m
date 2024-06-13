function output = lcg(x, c, m, a)
    % Mod 100 so the values don't go above 100
    % This inherently makes LCG much less random no matter what values are used
    output = mod(mod(c * x + a, m), 100) + 1;