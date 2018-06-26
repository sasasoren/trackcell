function [b, vi, mcost, counter] = mumshah_pixel(Original_pic,L_perf, num_seg)
%In this function we have Original_pic as our image which we want to find the accurate boundary segments for,
%L_perf as segmentation of Original_pic and num_seg is the segment that we
%want to find the accurate boundary for that.
% num_seg is the number or label of the cell that we want to do the mum-sha
%h on that
%Outputs:
%b: matrix of pixels as the boundary after the the function
% vi : image of 0,1,2 and 3 which 0:out of segmentation. 1: Interior set. 2:
% boundary. 3: Exterior set.
%mcost: array of cost as in first col and pixel of changed from Interior
%set as the 2nd and 3rd cols.
%counter: number of iteration


l= bwlabel(L_perf); %labeling segmentation
[m, n] = size(Original_pic);
dimg = imgradient(Original_pic);% Gradient of image
beta = .5;
gamma = .5;
mcost =[]; % minimum cost in each iteration
lcost =[]; % minimum of cost for each pixel w.r.t. its neighbors
counter = 1;
grad_cost = 1;% difference of new cost minu last cost

% changing  the labeled segmentation to 1 on target segment and zero other
% places
vi=l;
vi(vi~=num_seg)=0;
vi=vi/num_seg;

% finding initial boundary of the target segment
bo = bwboundaries(vi,4);
b = bo{1}; %segment boundary
b(1,:)=[];

% this positive-negetavi array is using for 4-neghbor pixels
pm = [0,1, 0, -1,0];

% First we are changing the value of all pixel in boundary from 1 to 2
% here we pixels with value of one belongs to interior set, two belongs
% to boundary set and three belongs to exterior set
vi(sub2ind([m , n],b(:,1),b(:,2)))=2;
% we have this loop until gradient of cost function would be greater than
% epsilon
while true
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
                if isempty(extr) % finding all cost function for 4-neighbors of each pixel of boundary and save it in cost_nigh
                    cost_neigh(k,1) = sum((Original_pic(intr)-(sum(Original_pic(intr))/length(intr))).^2) + sum(dimg(intr).^2) + beta * length(bound) / 2;
                else
                    cost_neigh(k,1) = sum((Original_pic(intr)-(sum(Original_pic(intr))/length(intr))).^2) + sum(dimg(intr).^2) + sum((Original_pic(extr)-(sum(Original_pic(extr))/length(extr))).^2) + sum(dimg(extr).^2) + beta * length(bound) / 2;
                end%adding coordinate of those removed pixels to cost_nigh
                cost_neigh(k,2:3) = [b(l,1)+pm(k),b(l,2)+pm(k+1)];
            else% if the neighborhood pixel was not in interior set we assign infinity to its cost.
                cost_neigh(k,1) = inf;
                cost_neigh(k,2:3) = [b(l,1)+pm(k),b(l,2)+pm(k+1)];
            end
        end
        % finding the minimum of neighborhood and save cost value and the
        % pixel in lcost.
        c = cost_neigh(cost_neigh(:,1)==min(cost_neigh(:,1)),:);
        lcost(l,:) = c(1,:);% if we have more than one equal minimum here we will choose the first one
    end
    % minimum of all lcost is global cost for each iteration we save it in
    % mcost.
    gc = lcost(lcost(:,1)==min(lcost(:,1)),:);
    mcost(counter,:) = gc(1,:);
    if counter > 1
        grad_cost = mcost(counter,1) - mcost(counter-1,1);
        %if gradient of cost function was greater than 0 stop.
        if grad_cost > 0
            break
        end
    end
    % now we are changing the value of pixel from one(for interior) to two(
    %for boundary).
    vi(mcost(counter,2),mcost(counter,3)) = 2;% cost_neigh(cost_neigh(:,1)==min(cost_neigh(:,1))); is the optimized pixel for cost function
    
    counter = counter + 1;
end



%It is an optinal part. Sometimes the interior set and boundary are mixing
%together which we can not distinguish them. In this part we are removing
%all interior pixels which doesn't have any other interior pixel in
%4-neighborhood.

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
b = zeros(length(find(vi ==2)),2);
[b(:,1),b(:,2)] = find(vi == 2);
