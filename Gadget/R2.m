function R2 = aaaa(y, oy)
    n = 89266;
    MSEy = sum((mean(y) - y) .^ 2) ./ n;
    MSEoy = sum((oy - y) .^ 2) ./ n;
    R2 = 1 - MSEoy ./ MSEy;
end
