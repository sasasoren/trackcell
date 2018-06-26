function z = intersectfind(A,B)
    % A: list of points in that we want to see if B is in those points or not, if B
    % is in A it returns true else it is false.
    l=length(A(:,1));
    z=false;
    if l>1
        for i = 1:l
            if ((A{i,1}==B(1,1))&&(A{i,2}==B(1,2)))
                z=true;
                break
            end
        end 
    elseif l==1
        if ((A{1,1}==B(1,1))&&(A{1,2}==B(1,2)))
                z=true;
        end
    end
end