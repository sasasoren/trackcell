function mean_boundary_segment=meanBS(Original_pic,L_new_mod)
% Inputs are part or whole of Original picture as Original_pic and output
% of watershed after histogram equaization. The output is mean of boundary
% segment of cells from L_new_mod

% Compute the mean intensity for  the neigborhoods  BS1 ,BS2 of  size 1, size2  of each
% boundary segment BS;
% define BS0 = BS
% define
% mBSj = meanBSj =  sum of intensities in BSj / cardinal BSj   for j= 0,1,2
[L,W]=size(Original_pic);
B=rem_imperf(L_new_mod);
pic_segs = segfind(B,L_new_mod);
l=length(pic_segs);
num_vicinity = 2;
Sum_vicinity=[];mBS=[];card_seg=[];
for j = 0:num_vicinity %loop for different size of vicinity
    for i = 1:l %loop for all the segments of the image
        s=0;
        x=0;
        y=0;
        l2=length(pic_segs{i});
        for k = 1:l2 %loop for all the pixels of the sement
            x1=x;
            y1=y;
            x=cell2mat(pic_segs{i}(k,1));
            y=cell2mat(pic_segs{i}(k,2));
            AB=[];
            if x-x1==1
                if x+j<=L
                    AB=Original_pic(x+j,y-j:y+j);
                    s=sum(sum(AB))+s;
                else
                    break;
                end
            elseif x1-x==1
                if x-j>=1
                    AB=Original_pic(x-j,y-j:y+j);
                    s=sum(sum(AB))+s;
                else
                    break;
                end
            elseif y-y1==1
                if y+j<=W
                    AB=Original_pic(x-j:x+j,y+j);
                    s=sum(sum(AB))+s;
                else
                    break;
                end
            elseif y1-y==1
                if y-j>=1
                    AB=Original_pic(x-j:x+j,y-j);
                    s=sum(sum(AB))+s;
                else
                    break;
                end
            else
                try   % here if the segment is so close to edge of image that j=2 or more can not work break the for loop and leave zero instead of that.
                    AB=Original_pic(x-j:x+j,y-j:y+j);   
                    s=sum(sum(AB))+s;
                catch
                    s=0;
                    break
                end
            end
        end
        Sum_vicinity(j+1,i)=s;
        card_seg(j+1,i)=(l2+2*j)*(2*j+1);
        mBS(j+1,i)=Sum_vicinity(j+1,i)/(card_seg(j+1,i)*(1+2*j));
    end
end
 mean_boundary_segment = mBS;