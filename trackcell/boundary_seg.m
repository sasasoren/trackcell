function image_boundary=boundary_seg(L_perfect,L_new_mod)
% L_new_mod is the cells image without removing imperfect cells
% L_perfect is the image after using rem_imperf
%compute and store the boundary segments of each region


pic=L_perfect;
lpic=bwlabel(L_perfect);
pic_segs = segfind(L_perfect,L_new_mod);
l=length(pic_segs);
max_lpic=max(max(lpic));
cells_seg=cell(max_lpic,1);
for i=1:l
    Counter_exist=zeros(max_lpic,1);
    if length(pic_segs{i})>4
    for j=1:4 % this for loop will count number of adjacent cells to a segment for four first pixels of each segment
        x=cell2mat(pic_segs{i}(j,1));
        y=cell2mat(pic_segs{i}(j,2));
        if pic(x+1,y)~=0
            r=lpic(x+1,y);
            Counter_exist(r,1)=Counter_exist(r,1)+1;
            if (Counter_exist(r,1)==2)
            k=length(cells_seg{r});
            k=k+1;
            cells_seg{r}{k}=pic_segs{i};
            end
        end
        if pic(x-1,y)~=0
            r=lpic(x-1,y);
            Counter_exist(r,1)=Counter_exist(r,1)+1;
            if (Counter_exist(r,1)==2)
            k=length(cells_seg{r});
            k=k+1;
            cells_seg{r}{k}=pic_segs{i};
            end
        end
        if pic(x,y+1)~=0
            r=lpic(x,y+1);
            Counter_exist(r,1)=Counter_exist(r,1)+1;
            if (Counter_exist(r,1)==2)
            k=length(cells_seg{r});
            k=k+1;
            cells_seg{r}{k}=pic_segs{i};
            end
        end
        if pic(x,y-1)~=0
            r=lpic(x,y-1);
            Counter_exist(r,1)=Counter_exist(r,1)+1;
            if (Counter_exist(r,1)==2)
            k=length(cells_seg{r});
            k=k+1;
            cells_seg{r}{k}=pic_segs{i};
            end
        end
    end
    else 
        for j=1:3
            try
        x=cell2mat(pic_segs{i}(j,1));
        y=cell2mat(pic_segs{i}(j,2));
        if pic(x+1,y)~=0
            r=lpic(x+1,y);
            Counter_exist(r,1)=Counter_exist(r,1)+1;
            if (Counter_exist(r,1)==2)
            k=length(cells_seg{r});
            k=k+1;
            cells_seg{r}{k}=pic_segs{i};
            end
        end
        if pic(x-1,y)~=0
            r=lpic(x-1,y);
            Counter_exist(r,1)=Counter_exist(r,1)+1;
            if (Counter_exist(r,1)==2)
            k=length(cells_seg{r});
            k=k+1;
            cells_seg{r}{k}=pic_segs{i};
            end
        end
        if pic(x,y+1)~=0
            r=lpic(x,y+1);
            Counter_exist(r,1)=Counter_exist(r,1)+1;
            if (Counter_exist(r,1)==2)
            k=length(cells_seg{r});
            k=k+1;
            cells_seg{r}{k}=pic_segs{i};
            end
        end
        if pic(x,y-1)~=0
            r=lpic(x,y-1);
            Counter_exist(r,1)=Counter_exist(r,1)+1;
            if (Counter_exist(r,1)==2)
            k=length(cells_seg{r});
            k=k+1;
            cells_seg{r}{k}=pic_segs{i};
            end
        end
            catch
                if (Counter_exist(r,1)==1)
                    k=length(cells_seg{r});
                    k=k+1;
                    cells_seg{r}{k}=pic_segs{i};
                end
                continue
            end
        end
    end
end
image_boundary=cells_seg;