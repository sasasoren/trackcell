function show = show_label(L_perfect)
%this function shows label of each cell
lpic = bwlabel(L_perfect);
for i = 1:max(max(lpic))
    [I J]=ind2sub(size(lpic),find(lpic ==i));
    Cx(i)= floor(sum(I)/length(I));
    Cy(i)= floor(sum(J)/length(J));
    text(Cy(i)-4,Cx(i),num2str(i),'Color','red');
end