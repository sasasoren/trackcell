function [classify, dot_vec] = cell_classify(L_new_mod , Joint_cell)

%Classify the orientation of boundaries, lengthwise or widthwise.
% Here we are using joint_cell, eigenvector(V), pic_segs

L_perfect=rem_imperf(L_new_mod);
pic_segs = segfind(L_perfect,L_new_mod);
len_joint = length(Joint_cell);


lpic=bwlabel(L_perfect);
Bound = bwboundaries(lpic);
len_pic=max(max(lpic));
for i = 1:len_pic %Finding the eigen value and eigen vector of each cell
    [I, J]=ind2sub(size(lpic),find(lpic ==i));
    Cx(i)= sum(I)/length(I);
    Cy(i)= sum(J)/length(J);
    I1=I-Cx(i);
    J1=J-Cy(i);
    X=[I J];
    X1=[I1 J1];
    C=X1'*X1;
    [V{i}, E{i}] = eig(C);
end






classify = {};
for i = 1:len_joint
    if ((Joint_cell(i,1)>0) && (Joint_cell(i,2)>0))
        u1 = cell2mat(pic_segs{i}(1,:))-cell2mat(pic_segs{i}(length(pic_segs{i}),:));%u is vector of segment (first - last)
        u = u1/norm(u1);
    dot_vec(i,1)= abs(V{Joint_cell(i,1)}(1,:)*u')/norm(u);
    dot_vec(i,2)= abs(V{Joint_cell(i,1)}(2,:)*u')/norm(u);
    if dot_vec(i,1) >= dot_vec(i,2)
        classify{i,1}= 'Horizontal';
    else
        classify{i,1}= 'Vertical';
    end
    dot_vec(i,3)= abs(V{Joint_cell(i,2)}(1,:)*u')/norm(u);
    dot_vec(i,4)= abs(V{Joint_cell(i,2)}(2,:)*u')/norm(u);
    if dot_vec(i,3) >= dot_vec(i,4)
        classify{i,2}= 'Horizontal';
    else
        classify{i,2}= 'Vertical';
    end
    end
end
% for i=1:len_joint
%      if (~isequal(cell_classify{i,1},cell_classify{i,2}))
%          i
%      end
% end