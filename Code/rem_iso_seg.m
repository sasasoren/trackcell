function perf = rem_iso_seg(L_perf, joint)
%This function remove Isolated segment of image after histogram
%equalization, watershed and removing imperfect segmentations.



perf = L_perf;
label = bwlabel(perf);
for i = 1:max(max(label))
    if ~any(joint == i)
        perf(label == i) = 0;
    end
end

        