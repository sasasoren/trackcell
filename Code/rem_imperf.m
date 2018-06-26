function L_img_new = rem_imperf(L_img)
% This function ask L_img as input and remove all imperfect cells from
% image and returns L_img_new as image of removed imperfect cells


lpic=bwlabel(L_img); %We are labling all cells
[L,W]=size(lpic);
for i=1:L % in these two for loop we find cells those have a pixel on the edge of image and set their label equal to zero 
    if lpic(i,1)~=0
        x=lpic(i,1);
        lpic(lpic==x)=0;
    end
        if lpic(i,W)~=0
        x=lpic(i,W);
        lpic(lpic==x)=0;
    end
end
for i=1:W
    if lpic(1,i)~=0
        x=lpic(1,i);
        lpic(lpic==x)=0;
    end
        if lpic(L,i)~=0
        x=lpic(L,i);
        lpic(lpic==x)=0;
    end
end
lpic(lpic~=0)=1;%we are setting all cells which are not equal to zero to 1

L_img_new=lpic;