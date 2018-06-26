function [perf, new, critic] = area_rem_seg(L_perf, L_new, mbs, area, joint, thrshld)

% This function remove some segments which make baby cells w.r.t. components least mean boundary segment., 
%the inputs are:
%L_new: image after histogram equalization and watershed.
%L_perf: L_new after removing incomplete segments.
%mbs: mean of boundary segments.
%area: area w.r.t. pixel of each component.
%joint: a matrix which the numbers in each row represent the number of
%segment and the number of that row represent the intersection boundary
%segment.
%thrshld:  We will join all segments which their area is less than that
%number to its neighbor w.r.t. least mbs.


perf = L_perf;
new = L_new;
w = segfind(perf,new);
mBS = mbs;
les_thr = find(area<thrshld);
critic =[];
count = 1;
for i = 1:length(les_thr)
    seg_joint = find(joint == les_thr(i));
    if isempty(seg_joint) < 1
    for j = 1:length(seg_joint)
        if seg_joint(j)>length(joint)
            seg_joint(j) = seg_joint(j) - length(joint);
        end
    end
    seg_del(i) = seg_joint(mBS(seg_joint) == min(mBS(seg_joint)));
    critic(count) = seg_del(i);
            intseg = cell2mat(w{seg_del(i)}); 
            intseg(1,:)=[];
            for k = 1:length(intseg)
                x = intseg(k,1);
                y = intseg(k,2);
                perf(x,y,1)=1;
                new(x,y,1)=1;
            end
            count = count + 1;
    end
end









