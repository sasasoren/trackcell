function [lgRk, wdRk, V, E, aRk, bRk, rat, lrat] = cell_characterization(L_perfect)
%characterize each region R = Rk by shape features
% 
% aRk =areaR
% bRk = total boundary length of Rk
% implement PCA for Rk
% this yields  2 eigenvalues of L1(k) >= L2(k) >= 0
% and two eigenvectors V1(k), V2(k)
% compute
% the ratio rat(k) = L2/L1
% LgRk = length of projection of Rk onto eigenvector V1(k)
% WdRk = length of  projection of Rk onto eigenvector V2(k)
% 
% plot 5 histograms  of arK, bRk, rat(k), LgRk, WdRk
lpic=bwlabel(L_perfect);
Bound = bwboundaries(lpic);
len_pic=max(max(lpic));
for i = 1:len_pic
    [I, J]=ind2sub(size(lpic),find(lpic ==i));
    Cx(i)= sum(I)/length(I);
    Cy(i)= sum(J)/length(J);
    I1=I-Cx(i);
    J1=J-Cy(i);
    X=[I J];
    X1=[I1 J1];
    C=X1'*X1;
    [V{i}, E{i}] = eig(C);
    V1=V{i}(:,1)'*X';
    V2=V{i}(:,2)'*X';
    wdRk(i)=max(V1)-min(V1);
    lgRk(i)=max(V2)-min(V2);
    bRk(i)=length(Bound{i})-1;
    aRk(i)=length(I);
    rat(i)=E{i}(1)/E{i}(4);
    lrat(i)=aRk(i)/bRk(i);
end

end