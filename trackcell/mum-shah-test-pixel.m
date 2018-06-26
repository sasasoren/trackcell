

% Original_pic=seq_pic{1}{1,18};
%L_perf= seq_pic{1}{1,19};
l= bwlabel(L_perf);
[m, n] = size(Original_pic);
boundary = {};
new_boundary = ones(m,n,3);
dimg = imgradient(Original_pic);
beta = .5;
gamma = .5;
tcost =[];
lcost =[];
counter = 1;
epsilon = .00005; % threshold for stopping algorithm
grad_cost = 1;


vi=l;
vi(vi~=1)=0;
vi=vi/1;
zi = vi;
bo = bwboundaries(vi,4);
b = bo{1};
b(1,:)=[];
i=1;
pm = [0,1, 0, -1,0];

    % First we are changing the value of all pixel in boundary to 2
vi(sub2ind([m , n],b(:,1),b(:,2)))=2;
while true  
%     % If one pixel of interior set did not have any 4-neighbor of interior
%     % set change it to boundary
%     o = zeros(length(find(vi ==1)),2);
%     [o(:,1),o(:,2)] = find(vi == 1);
%     for j = 1:length(o)
%         if vi(o(j,1)-1,o(j,2)) ~= 1 && vi(o(j,1),o(j,2)-1) ~= 1 && vi(o(j,1)+1,o(j,2)) ~= 1 && vi(o(j,1),o(j,2)+1) ~= 1
%             vi(o(j,1),o(j,2)) = 2;
%         end
%     end
    %In this loop we are adding all x in B(I, O), which they don’t have any
    %element of I in their 8-neighbor, to O.(change their value from 2
    %to 3.)
    b = zeros(length(find(vi ==2)),2);
    [b(:,1),b(:,2)] = find(vi == 2);% b(:,1)row coordinate of borders pixel and b(:,2) col coordinate
    for j = 1:length(b)
        if ~(vi(b(j,1)-1,b(j,2)-1) == 1 || vi(b(j,1),b(j,2)-1) == 1 || vi(b(j,1)+1,b(j,2)-1) == 1|| vi(b(j,1)-1,b(j,2)) == 1|| vi(b(j,1)+1,b(j,2)) == 1|| vi(b(j,1)-1,b(j,2)+1) == 1|| vi(b(j,1),b(j,2)+1) == 1|| vi(b(j,1)+1,b(j,2)+1) == 1)
            vi(b(j,1),b(j,2)) = 3;
        end
    end
    b = zeros(length(find(vi ==2)),2);
    [b(:,1),b(:,2)] = find(vi == 2);
    cost_neigh = [];
    xstar = [];
    lcost = [];
    for l = 1:length(b)
        % In this loop we are moving around all pixel of boundary and we
        % will find min of cost function for pixells neighbor, after that,
        % we will save cost and coordinate of pixel in lcost variable.
        for k = 1:4
            if vi(b(l,1)+pm(k),b(l,2)+pm(k+1)) == 1
                temp_vi = vi;%making an temporary image that we can change the value b(j,1)+pm(j),b(j,2)+pm(j+1) to the border which is 2.
                temp_vi(b(l,1)+pm(k),b(l,2)+pm(k+1)) = 2;
                temp_bound = zeros(length(find(temp_vi==2)),2);
                [temp_bound(:,1), temp_bound(:,2)] = find(temp_vi == 2);
                for j = 1:length(temp_bound(:,1))
                    if ~(temp_vi(temp_bound(j,1)-1,temp_bound(j,2)-1) == 1 || temp_vi(temp_bound(j,1),temp_bound(j,2)-1) == 1 || temp_vi(temp_bound(j,1)+1,temp_bound(j,2)-1) == 1|| temp_vi(temp_bound(j,1)-1,temp_bound(j,2)) == 1|| temp_vi(temp_bound(j,1)+1,temp_bound(j,2)) == 1|| temp_vi(temp_bound(j,1)-1,temp_bound(j,2)+1) == 1|| temp_vi(temp_bound(j,1),temp_bound(j,2)+1) == 1|| temp_vi(temp_bound(j,1)+1,temp_bound(j,2)+1) == 1)
                        temp_vi(temp_bound(j,1),temp_bound(j,2)) = 3;
                    end
                end
                extr = find(temp_vi == 3);
                bound = find(temp_vi == 2);
                intr = find(temp_vi == 1);
                if isempty(extr)
                    cost_neigh(k,1) = sum(Original_pic(intr).^2) + sum(dimg(intr).^2) + beta * length(bound) / 2;
                else
                    cost_neigh(k,1) = sum(Original_pic(intr).^2) + sum(dimg(intr).^2) + sum((Original_pic(extr)-1).^2) + sum(dimg(extr).^2) + beta * length(bound) / 2;
                end
                cost_neigh(k,2:3) = [b(l,1)+pm(k),b(l,2)+pm(k+1)];
            else
                cost_neigh(k,1) = inf;
                cost_neigh(k,2:3) = [b(l,1)+pm(k),b(l,2)+pm(k+1)];
            end
        end
        c = cost_neigh(cost_neigh(:,1)==min(cost_neigh(:,1)),:);
        lcost(l,:) = c(1,:);% if we have more than one equal minimum here we will choose the first one
    end
    gc = lcost(lcost(:,1)==min(lcost(:,1)),:);
    tcost(counter,:) = gc(1,:);
    if counter > 1
        grad_cost = tcost(counter,1) - tcost(counter-1,1);
        if grad_cost > 0
            break
        end
    end
    vi(tcost(counter,2),tcost(counter,3)) = 2;% cost_neigh(cost_neigh(:,1)==min(cost_neigh(:,1))); is the optimized pixel for cost function
    
    counter = counter + 1;
%     if counter>500
%         break
%     end
end


%%


    % If one pixel of interior set did not have any 4-neighbor of interior
    % set change it to boundary
    o = zeros(length(find(vi ==1)),2);
    [o(:,1),o(:,2)] = find(vi == 1);
    for j = 1:length(o)
        if vi(o(j,1)-1,o(j,2)) ~= 1 && vi(o(j,1),o(j,2)-1) ~= 1 && vi(o(j,1)+1,o(j,2)) ~= 1 && vi(o(j,1),o(j,2)+1) ~= 1
            vi(o(j,1),o(j,2)) = 2;
        end
    end

        b = zeros(length(find(vi ==2)),2);
    [b(:,1),b(:,2)] = find(vi == 2);% b(:,1)row coordinate of borders pixel and b(:,2) col coordinate
    for j = 1:length(b)
        if ~(vi(b(j,1)-1,b(j,2)-1) == 1 || vi(b(j,1),b(j,2)-1) == 1 || vi(b(j,1)+1,b(j,2)-1) == 1|| vi(b(j,1)-1,b(j,2)) == 1|| vi(b(j,1)+1,b(j,2)) == 1|| vi(b(j,1)-1,b(j,2)+1) == 1|| vi(b(j,1),b(j,2)+1) == 1|| vi(b(j,1)+1,b(j,2)+1) == 1)
            vi(b(j,1),b(j,2)) = 3;
        end
    end


%%
% Original_pic=seq_pic{1}{1,18};
[x y] = find(vi == 2);
[x2 y2] = find(vi ==0);
for i = 1:length(x)
    Original_pic(x(i),y(i),1)=1;
Original_pic(x(i),y(i),2)=1;
Original_pic(x(i),y(i),3)=0;

Original_pic(x2(i),y2(i),1)=1;
Original_pic(x2(i),y2(i),2)=1;
Original_pic(x2(i),y2(i),3)=1;
end
for i = 1:length(x2)
Original_pic(x2(i),y2(i),1)=1;
Original_pic(x2(i),y2(i),2)=1;
Original_pic(x2(i),y2(i),3)=1;
end








