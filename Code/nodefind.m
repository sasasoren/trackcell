function z = nodefind(A)
    % A: Image input that we want to find the intersection of edges
    [x,y]=size(A);
    z={};
    k=0;
    for i = 2:(x-1)
        for j = 2:(y-1)
                if ((A(i,j)==0) && (sum([A(i,j+1)==0,A(i,j-1)==0,A(i+1,j)==0,A(i-1,j)==0])>=3))
                    k=k+1;
                    z(k,1:2)={i,j};
                end
        end
    end             
end