function errorr = fun(x, inputnum, hiddennum, outputnum, net, inputn, outputn)
    w1 = x(1:inputnum * hiddennum);
    B1 = x(inputnum * hiddennum + 1 : inputnum * hiddennum + hiddennum);
    w2 = x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
    B2 = x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);

    net = newff(inputn, outputn, hiddennum);
    
end