function x = componenthist(A)
    % A: Image input that we want to find the number of connected component
    % on this and return histogram of numbers of connected component
    
    L = bwlabel(A);
    y=max(max(L));
    for i = 1:y
        x(i)= nnz(L==i);
    end
end