%This file is for writing the code that disscussed in Feb 23 2018 among I,
%Robert and Andreas.
%% Soren Reading the file

SI = imread('/home/sorena/Documents/Spyderthon/Project/With tiff/phase.tif');
SI = double(SI)/double(max(max(SI)));
I_1 = SI(600:1200,2000:11000);

ws_region = I_1;%(100:227,400:463);
%imshow(I_1),title('Original Image');

%% Histogram Equalization and watershed
[pixelCount,grayLevels] = imhist(I_1);
cdf = cumsum(pixelCount)/sum(pixelCount);
seg_resh = im2uint8(I_1);
G = cdf(seg_resh);

% quantitative measures
mean_1 = mean(mean(G));
std_1 = std(std(G));
%imhist(G); %saveas(gcf,'hist_1','png'); 
l2_1 = norm(G);

% watershed transform for G
%G_region = G;
G_region = G(100:355,400:655);
G_new = imhmin(G_region,0.17);
L_new = watershed(G_new);
L_new_mod = L_new;
L_new_mod(L_new_mod ~= 0) = 1;
% figure,
% subplot(1,2,1), 
% imshow(L_new_mod,[]);
% title('Watershed line for G with 0.17 suppression');
% fused = imfuse(L_new_mod,G_region);
% subplot(1,2,2),
% imshow(fused);
% 
% saveas(gcf,'combo','png');
%% Removing not completed cells
lpic=bwlabel(L_new_mod);
[L,W]=size(lpic);
for i=1:L
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
lpic(lpic~=0)=1;

figure,
subplot(1,2,1), 
imshow(lpic,[]);
title('Watershed line for G with 0.17 suppression');
fused = imfuse(L_new_mod,G_region);
subplot(1,2,2),
imshow(fused);
L_new_mod=lpic;
    %% 1) compute and plot all  quantiles 1% to 100% for the  areas of all connected regions
%generated by watershed algo.

cell_area = componenthist(L_new_mod); % For each number 'i' for cell_area we have area of related cell with number 'i'.
% ploting cdf:
cdfplot(cell_area);

%% 2) select  quantiles 5% 25% 50% 75% 95%
% this defines 6 intervals for quantiles
% select 6 colors , one for for each interval ,
% color each region according to this color scheme
% display
sort_cell_area=sort(cell_area);
len_area =length(cell_area);
q=[5 25 50 75 95];
x=[];
quan=[];
for i= 1:100
    x(i)=floor(i*len_area/100);
    if x(i)==0
        quan(i)=0;
    else
        quan(i)=sort_cell_area(x(i));
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
for i = 1:len_area
    labeled_cell(labeled_cell== i)= cell_label(i);
end
[M,N] = size(L_new_mod);
%1:red
%2:green
%3:blue
%4:yellow
%5:cyan
%6:magenta
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
figure,
subplot(1,2,1), 
imshow(labeled_cell,[]);
title('labeled cell by color');
fused = imfuse(L_new_mod,G_region);
subplot(1,2,2),
imshow(fused);
title('Original picture with Watershed');
%% 3) present  the different segmentations generated  by  Watershed algo for 3   different
% values of the suppression parameter sp1 sp2 sp3
% redo 1) for each sp1 sp2 sp3
val=[.1 .15 .17 .21 .3];
figure,
for i = 1:5
    G1 = imhmin(G_region,val(i));
L = watershed(G1);
L2 = L;
L2(L2 ~= 0) = 1;
subplot(2,3,i)
imshow(L2,[]);
title([num2str(val(i)) ' Suppression']);
end


subplot(2,3,6),
imshow(G_region);
%% 3)b)
cell_area = componenthist(L_new_mod);
%Foor ploting cdf:
cell_cdf=cdfplot(cell_area);
for i = 1:5
    G1 = imhmin(G_region,val(i));
L = watershed(G1);
L2 = L;
L2(L2 ~= 0) = 1;
cell_area2 = componenthist(L2);
%For ploting cdf
subplot(2,3,i)
cell_cdf2=cdfplot(cell_area2);
title([num2str(val(i)) ' Suppression']);
end
%% 4) compute and store the boundary segments of each region

pic=L_new_mod;
lpic=bwlabel(L_new_mod);
pic_segs = segfind(L_new_mod);
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
cells_seg1=cells_seg;
%removing duplications
%  for i = 1:5
%      l_cell = length(cells_seg{i});
%      max_len_cell=0;
%      for j=1:l_cell
%          if (length(cells_seg{i}{j})>= max_len_cell/2)
%              max_len_cell = 2 * length(cells_seg{i}{j});
%          end
%      end
%      mat_cell=[];
%      for j=1:l_cell
%          l5=2*length(cells_seg{i}{j});
%          seg_resh=reshape(cell2mat(cells_seg{i}{j}),l5,1);
%          mat_cell(:,j)=padarray(seg_resh,max_len_cell - l5 +1,'post');
%      end
%      mat_cell=unique(mat_cell','rows');
%      mat_cell = mat_cell';
%      l3=size(mat_cell,2);
%      new_cell_seg={};
%      k2=1;
%      for j = 1:l3
%          seg = mat_cell(:,j);
%          seg(seg==0)=[];
%          l4=length(seg)/2;
%          seg=reshape(seg,l4,2);
%          new_cell_seg{k2}=seg;
%          k2=k2+1;
%      end
%      cells_seg{i}=new_cell_seg;
% end
%% 5) Compute the mean intensity for  the neigborhoods  BS1 ,BS2 of  size 1, size2  of each
% boundary segment BS;
% define BS0 = BS
% define
% mBSj = meanBSj =  sum of intensities in BSj / cardinal BSj   for j= 0,1,2
Original_pic=G_region;
[L,W]=size(Original_pic);
pic=L_new_mod;
lpic=bwlabel(L_new_mod);
pic_segs = segfind(L_new_mod);
l=length(pic_segs);
num_vicinity = 2;
Sum_vicinity=[];mBS=[];card_seg=[];
for j = 0:num_vicinity %loop for different size of vicinity
    for i = 1:l %loop for all the segment of the image
        s=0;
        x=0;
        y=0;
        l2=length(pic_segs{i});
        for k = 1:l2 %loop for all the pixels of the sement
            x1=x;
            y1=y;
            x=cell2mat(pic_segs{i}(k,1));
            y=cell2mat(pic_segs{i}(k,2));
            A=[];
            if x-x1==1
                if x+j<=L
                    A=Original_pic(x+j,y-j:y+j);
                    s=sum(sum(A))+s;
                else
                    break;
                end
            elseif x1-x==1
                if x-j>=1
                    A=Original_pic(x-j,y-j:y+j);
                    s=sum(sum(A))+s;
                else
                    break;
                end
            elseif y-y1==1
                if y+j<=W
                    A=Original_pic(x-j:x+j,y+j);
                    s=sum(sum(A))+s;
                else
                    break;
                end
            elseif y1-y==1
                if y-j>=1
                    A=Original_pic(x-j:x+j,y-j);
                    s=sum(sum(A))+s;
                else
                    break;
                end
            else
                try   % here if the segment is so close to edge of image that j=2 or more can not work break the for loop and leave zero instead of that.
                    A=Original_pic(x-j:x+j,y-j:y+j);   
                    s=sum(sum(A))+s;
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
    
%% 6) apply twice the basic  EROSION operator to each region R_1... R_K (see morphomaths
% functions in matlab) essentially to eliminate in each REG the pixels which are too close
% to the boundary , namely within two pixels of the boundary
% 
% this will define the interior IRk of Rk for all k =1 ... K
% compute the interior  mean of Rk by
% mIRk = sum of intensities in IRk / cardinal (IRk)
% 
% plot the histogram of all the mIRk
pic_mod=L_new_mod;
% modified_pic(:,:,1)=pic_mod;
% modified_labeled_pic(:,:,1)=bwlabel(modified_pic(:,:,1));
errosion_num=2; % how many times you want to have errosion on picture
sum_intensity=[];
[l,w]=size(pic_mod);
for j=0:errosion_num
    if j>0
    B=bwboundaries(pic_mod);
    set_boun_len=length(B);
    for i=1:set_boun_len
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
for i = 1:3
%Foor ploting cdf:
subplot(1,3,i)
hist(mIR(i,:))
title(['mIR' num2str(i-1)]);
end

%% 7) for EACH boundary segment BS
% there are two "adjacent"  regions R= some Rk and R' = some R_k' which admit BS as a
% common boundary segment
% call mIR and mIR' the interior means of R and R'
% define and compute the "crest height" of each BS by
% crhBS = mBS - (mIR + mIR')/2


% Joint matrix is a matrix that defines each segment is a common boundary
% of which two cells, it means for example first segment is a boundary of
% two cells which cell'snumbers are in first row of Joint_cell matrix.
pic_segs = segfind(L_new_mod);
seg_len = length(pic_segs);
%from part 4 we are defining cells_seg which is all segment surround a cell
cel_num=length(cells_seg);
Joint_cell=[];
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
    else
        
    crhBS(1,i)=mBS0(1,i)- abs((mIR0(1,Joint_cell(i,1))-mIR0(1,Joint_cell(i,2)))/2);
    end
    end
end








%% 8) plot the histogram of all the crhBS amd all the mBS, mBS0, mBS1, mBS2 , all the
% boundaries lengths card(BS0)

for i = 1:3
%Foor ploting cdf:
subplot(2,3,i)
hist(mBS(i,:),100)
title(['mBS' num2str(i-1) ]);
end
subplot(2,3,4)
hist(crhBS((crhBS~=0)))
title('crest height of BS')
for i=1:length(pic_segs)
    seg_len(i,1:2)=size(pic_segs{i});
end
subplot(2,3,5)
hist(seg_len(:,1));
title('Boundary length Card');

    
    













%% 9) characterize each region R = Rk by shape features
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
Bound = bwboundaries(lpic);
len_pic=max(max(lpic));
for i = 1:len_pic
    
    [I J]=ind2sub(size(lpic),find(lpic ==i));
    Cx(i)= sum(I)/length(I);
    Cy(i)= sum(J)/length(J);
    I1=I-Cx(i);
    J1=J-Cy(i);
    X=[I J];
    X1=[I1 J1];
    C=X1'*X1;
    [V{i} E{i}] = eig(C);
    V1=V{i}(:,1)'*X';
    V2=V{i}(:,2)'*X';
    wdRK(i)=max(V1)-min(V1);
    lgRK(i)=max(V2)-min(V2);
    bRK(i)=length(Bound{i})-1;
    aRK(i)=length(I);
    rat(i)=E{i}(1)/E{i}(4);
    lrat(i)=aRK(i)/bRK(i);
end

subplot(2,3,1)
hist(aRK)
title('aRK');

subplot(2,3,2)
hist(bRK)
title('bRK');

subplot(2,3,3)
hist(rat)
title('rat');

subplot(2,3,4)
hist(lgRK)
title('lgRK');

subplot(2,3,5)
hist(wdRK)
title('wdRK');

subplot(2,3,6)
hist(lrat)
title('lrat');


%% 10) plot  6   intensity graphs computes along   intersections of the image straight lines p
% Pick 3 lines cutting cells lengthwise and their 3 orthogonal lines 

int(1,:)=Original_pic(65,:);

int(2,:)=Original_pic(129,:);
int(3,:)=Original_pic(194,:);
int(4,:)=Original_pic(:,65);
int(5,:)=Original_pic(:,129);
int(6,:)=Original_pic(:,194);
for i = 1:6
subplot(2,3,i)
plot(int(i,:))
title('intensity graphs');
end























%% 3) For small picture
small_G = G_region(160:223,100:163);
val=[.1 .15 .17 .21 .3];
figure,
for i = 1:5
    G1 = imhmin(small_G,val(i));
L = watershed(G1);
L2 = L;
L2(L2 ~= 0) = 1;
subplot(2,3,i)
imshow(L2,[]);
title([num2str(val(i)) ' Suppression']);
end


subplot(2,3,6),
imshow(small_G);


