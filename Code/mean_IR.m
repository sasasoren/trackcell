function mIR = mean_IR(Original_pic,L_perfect)
% the input is Original pic and removed imperfect cell of lineared modified image of cell from
% histogram equalization and watershed. Output is mean of intensity of
% regions.

% apply twice the basic  EROSION operator to each region R_1... R_K (see morphomaths
% functions in matlab) essentially to eliminate in each REG the pixels which are too close
% to the boundary , namely within two pixels of the boundary
% 
% this will define the interior IRk of Rk for all k =1 ... K
% compute the interior  mean of Rk by
% mIRk = sum of intensities in IRk / cardinal (IRk)
% 
% plot the histogram of all the mIRk
pic_mod = L_perfect;
% modified_pic(:,:,1)=pic_mod;
% modified_labeled_pic(:,:,1)=bwlabel(modified_pic(:,:,1));
errosion_num=2; % how many times you want to have errosion on picture
sum_intensity=[];
for j=0:errosion_num
    if j>0
    B=bwboundaries(pic_mod);
    for i=1:length(B)
        bound_len = length(B{i});
        for k = 1:bound_len
        x=B{i}(k,1);
        y=B{i}(k,2);
        pic_mod(x,y)=0;
        end
    end
    end
    modified_pic(:,:,j+1)=pic_mod;
        modified_labeled_pic(:,:,j+1)=bwlabel(modified_pic(:,:,j+1));
        label_max=max(max(modified_labeled_pic(:,:,j+1)));
    for i=1:label_max
        sum_intensity(j+1,i)=sum(Original_pic(modified_labeled_pic(:,:,j+1)==i));
        cardinal_region(j+1,i)=length(find(modified_labeled_pic(:,:,j+1)==i));
        mIR(j+1,i)=sum_intensity(j+1,i)/cardinal_region(j+1,i);
    end
end




