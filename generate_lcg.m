function output = generate_lcg(row_num)
    output(1) = lcg(randi(1,10000));
    for n=2:row_num;
        output(n) = lcg(output(n-1));
    end
    output = output';