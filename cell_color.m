function L_color = cell_color(L_new_mod)
% L_new_mod is an image of 0 and 1 which is used after after histogram
% equalization and watershed also removing imperfect cells. the output is
% a colored imaged which seperated the different quantiles of 5% 25% 50% 75% 95%
% this defines 6 intervals for quantiles
% select 6 colors , one for for each interval , the colors are:
%1:red [0 , .05]
%2:green (.05 , .25]
%3:blue (.25 , .5]
%4:yellow (.5 , .75]
%5:cyan (.75 , .95]
%6:magenta (.95 , 1]

cell_area = componenthist(L_new_mod);
sorted_cell_area=sort(cell_area);
len_area =length(cell_area);
q=[5 25 50 75 95];
x=[];
quan=[];
for i= 1:100
    x(i)=floor(i*len_area/100);
    if x(i)==0
        quan(i)=0;
    else
        quan(i)=sorted_cell_area(x(i));
    end
end
% here we are labeling each cell with respect to their value of area
cell_label = cell_area;
cell_label(cell_label<=quan(q(1)))=1;
cell_label(quan(q(1))<cell_label & cell_label<=quan(q(2)))=2;
cell_label(quan(q(2))<cell_label & cell_label<=quan(q(3)))=3;
cell_label(quan(q(3))<cell_label & cell_label<=quan(q(4)))=4;
cell_label(quan(q(4))<cell_label & cell_label<=quan(q(5)))=5;
cell_label(quan(q(5))<cell_label)=6;

labeled_cell = bwlabel(L_new_mod);
for i = 1:len_area %specify the number 1:6 to all of the pixels of cell
    labeled_cell(labeled_cell== i)= cell_label(i);
end
%assigning color to each region
%1:red
%2:green
%3:blue
%4:yellow
%5:cyan
%6:magenta
[M N] = size(labeled_cell);
for i = 1:M
    for j = 1:N
        if labeled_cell(i,j)==1
            labeled_cell(i,j,1)=1;
            labeled_cell(i,j,2)=0;
            labeled_cell(i,j,3)=0;
        elseif labeled_cell(i,j)==2
            labeled_cell(i,j,1)=0;
            labeled_cell(i,j,2)=1;
            labeled_cell(i,j,3)=0;
            elseif labeled_cell(i,j)==3
            labeled_cell(i,j,1)=0;
            labeled_cell(i,j,2)=0;
            labeled_cell(i,j,3)=1;
            elseif labeled_cell(i,j)==4
            labeled_cell(i,j,1)=1;
            labeled_cell(i,j,2)=1;
            labeled_cell(i,j,3)=0;
            elseif labeled_cell(i,j)==5
            labeled_cell(i,j,1)=0;
            labeled_cell(i,j,2)=1;
            labeled_cell(i,j,3)=1;
            elseif labeled_cell(i,j)==6
            labeled_cell(i,j,1)=1;
            labeled_cell(i,j,2)=0;
            labeled_cell(i,j,3)=1;
        end
    end
end

L_color = labeled_cell;
end



% colored = zeros(M,N,3);
% for i= 1:6
%     a=fix(i/4);
%     b=fix((i- (a*4))/2);
%     c=mod(i,2);
%     colored(labeled_cell == i) = ?????????
% end


