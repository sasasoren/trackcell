function [boundary, cost, new_boundary] = mumshah(Original_pic,L_perf)
% Original_pic and L_Perf as input. this function find border of each
% component and and shrink the border and stop w.r.t. cost function of
% mumford-shah. 


l= bwlabel(L_perf);
nl = l;
zl = l;
[m n] = size(Original_pic);
boundary = {};
new_boundary = ones(m,n,3);
dimg = imgradient(Original_pic);
beta = .5;
gamma = .5;
cost =[];

for i = 1:max(max(l))
    nl=l;
    nl(nl~=i)=0;
    nl=nl/i;
    zl = nl;
    for j = 1:6
        b = bwboundaries(zl);
        boundary{i,j} = b{1};
        extr = find(nl>1);
        for k = 1:length(b{1})
            x = b{1}(k,1);
            y = b{1}(k,2);
            nl(x,y) = 8 -j;
            zl(x,y) = 0;
        end
        intr = find(nl == 1);
        if j == 1
            cost(i,j) = sum(Original_pic(intr).^2) + sum(dimg(intr).^2) + beta * length(b) / 2;
        else
            cost(i,j) = sum(Original_pic(intr).^2) + sum(dimg(intr).^2) + sum((Original_pic(extr)-1).^2) + sum(dimg(extr).^2) + beta * length(b) / 2;
            if cost(i,j)>cost(i,j-1)
                for k = 1:length(b{1})
                    x = b{1}(k,1);
                    y = b{1}(k,2);
                    new_boundary(x,y,1) = 0;
                end
                break
            end
        end
        
        if max(max(bwlabel(zl)))>1
            for k = 1:length(b{1})
                x = b{1}(k,1);
                y = b{1}(k,2);
                new_boundary(x,y,1) = 0;
            end
            break
        end
    end
end
