function show = cellsandsegment(Original_pic,L_perfect,label)
%this function shows Original image with segmentation w.r.t L_perfect, if
%instead of label you write ;T; it will give all before plus label of each
%component.

W = im2double(L_perfect)/1.5259e-05;
show = min(W,Original_pic);
imshow(min(W,Original_pic))
if nargin >2
    if label == 'T' 
        show_label(L_perfect)
    else
        print('If you want label you have fill the third argument with T')
    end
end


