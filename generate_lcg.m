function output = generate_lcg(row_num, x, c, m, a)
    output(1) = lcg(x, c, m, a);
    for n=2:row_num;
        output(n) = lcg(output(n-1), c, m, a);
    end
    output = output';