function [cut_seg , org_show] = cut_seg_img(Original_pic , L_perf , num_label , border, cut_edge,col)
% col =0 or 1


perf = L_perf;
org = Original_pic;
[M, N] = size(org);
org_show = ones(M,N);
label = bwlabel(perf);
cut_seg = [];
for j = 1:length(num_label)
    if col == 1
        org_s = ones(M,N);
    else
org_s = zeros(M,N);
    end
[x, y] = ind2sub(size(label),find(label == num_label(j))); 
for k = 1:length(x)
   org_s(x(k)-border:x(k)+border,y(k)-border:y(k)+border) = org(x(k)-border:x(k)+border,y(k)-border:y(k)+border);
   org_show(x(k)-border:x(k)+border,y(k)-border:y(k)+border) = org(x(k)-border:x(k)+border,y(k)-border:y(k)+border);
end
edge = border + cut_edge;
cut_seg{j} = org_s(min(x)-edge:max(x)+edge,min(y)-edge:max(y)+edge);
end





