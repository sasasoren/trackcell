function [crhBS , Joint_cell,f_crhBS, x_crhBS]=crest_height_BS(Original_pic,L_new_mod)
%for EACH boundary segment BS
% there are two "adjacent"  regions R= some Rk and R' = some R_k' which admit BS as a
% common boundary segment
% call mIR and mIR' the interior means of R and R'
% define and compute the "crest height" of each BS by
% crhBS = mBS - (mIR + mIR')/2


% Joint matrix is a matrix that defines each segment is a common boundary
% of which two cells, it means for example first segment is a boundary of
% two cells which cell'snumbers are in first row of Joint_cell matrix.

%from part 4 we are defining cells_seg which is all segment surround a cell
L_perfect=rem_imperf(L_new_mod);
cells_seg=boundary_seg(L_perfect,L_new_mod);
pic_segs = segfind(L_perfect,L_new_mod);
seg_len = length(pic_segs);
cel_num=length(cells_seg);
Joint_cell=[];
mBS = meanBS(Original_pic,L_new_mod);
mIR = mean_IR(Original_pic,L_perfect);
mBS0=mBS(1,:);
mIR0=mIR(1,:);
for i=1:seg_len
    if length(pic_segs{i}) >2 % we are removing all segments that they have length less than 2
    k1=1;
    for j = 1:cel_num
        cel_len=length(cells_seg{j});
        for k = 1:cel_len
            if (isequal(pic_segs{i},cells_seg{j}{k}))
                Joint_cell(i,k1)=j;
                k1=k1+1;
            end
        end
    end
    if ((Joint_cell(i,1)==0) || (Joint_cell(i,2)==0))
        crhBS(1,i)=0;
        delta(i)=0;
    else
    delta(i) = abs((mIR0(1,Joint_cell(i,1))-mIR0(1,Joint_cell(i,2)))/2);
    crhBS(1,i)=mBS0(1,i)- abs((mIR0(1,Joint_cell(i,1))+mIR0(1,Joint_cell(i,2)))/2);
    end
    end
end
[f_crhBS x_crhBS] = ecdf(crhBS);
end