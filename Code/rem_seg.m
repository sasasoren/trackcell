function [perf, new, critic] = rem_seg(L_perf, L_new, mbs, crest, thrshld, color)
%  rem_seg gives L_perf(image of components after edge removal),
%  L_new(image of components before edge removal), mbs (mean Boundary
%  Segment)n crest ( crest-height boundarysegment), thrshld( Threshhold for 
%removing boundary segmentation) and color( \you can instead of removing
% the boundary color the boundary, and gives you perf L_perf after removing
% proper boundary, new as same for L_new and critic number of segments that
% removed.
%thrshld and color are optional variable.

if nargin > 6
    error('TooManyInputs', 'requires at most 2 optional inputs');
end

% Fill in unset optional values.
switch nargin
    case 4
        thrshld = .01;
        color = 'F';
    case 5
        color = 'F';
end
% finding the numbers of segment which their mBS are less than the
% threshhold
z = find(mbs<=quantile(mbs,thrshld));

% finding all segments of L_perf
w = segfind(L_perf,L_new);
critic =[];

% for coloring the segments we change perf and new to 3D
perf = cat(3,L_perf,L_perf,L_perf);
new = cat(3,L_new,L_new,L_new);

k=1;
if color == 'T' % for color segment
    for i = 1:length(z)
        if crest(z(i))<=quantile(crest , thrshld) % finding the numbers of segments which their mBS and mIR are less than threshhold
            critic(k) = z(i);
            intseg = cell2mat(w{z(i)}); 
            intseg(1,:)=[];
            for j = 1:length(intseg)
                x = intseg(j,1);
                y = intseg(j,2);
                perf(x,y,1)=1;
                new(x,y,1)=1;
            end
            k=k+1;
        end
    end
else
    for i = 1:length(z) % here as same as above but for removing the segment not coloring
        if crest(z(i))<=quantile(crest , thrshld)
            critic(k) = z(i);
            intseg = cell2mat(w{z(i)});
            intseg(1,:)=[];
            L_perf(sub2ind(size(L_perf),intseg(:,1),intseg(:,2)))=1;
            L_new(sub2ind(size(L_perf),intseg(:,1),intseg(:,2)))=1;
            k=k+1;
        end
    end
    perf = [];
    perf = L_perf;
    new = [];
    new = L_new;
end


    
    
    
    
