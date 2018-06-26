function s = segfind(After_rem_imperf,Before_rem_imperf)
    % B: Input image that we want to find the segments of Image(after
    % rem_imperf)
    % A: Input image before rem_imperf
    z=nodefind(Before_rem_imperf);
    k=1;
    seg={};
    w=length(z);
    for i = 1:w
        x = cell2mat(z(1,1));
        y = cell2mat(z(1,2));
        z(1,:)=[];
        for i = 1:4
            try
                [seg{k},Before_rem_imperf]=oneseg(Before_rem_imperf,x,y,z);
                k=k+1;
            catch
                continue
            end
        end
    end
    for i=length(seg):-1:1 % in this for loop we eliminate all segment which is not in not a segment for image, after removing the imperfect cells
        if length(seg{i})>5
            for j=3:(length(seg{i})-2)
                x = cell2mat(seg{i}(j,1));
                y = cell2mat(seg{i}(j,2));
                if nnz(After_rem_imperf(x-1:x+1,y-1:y+1)==0)>=6% if in one of the pixel of the segment is on the removed area
                    seg(i)=[];
                    break
                end
            end
        elseif length(seg{i})>=3
            for j=2:(length(seg{i})-1)
                x = cell2mat(seg{i}(j,1));
                y = cell2mat(seg{i}(j,2));
                if nnz(After_rem_imperf(x-1:x+1,y-1:y+1)==0)>=6% if in one of the pixel of the segment is on the removed area
                    seg(i)=[];
                    break
                end
            end
        else
            seg(i)=[];%removing all segments of length 2
        end
    end
    % For adding segment without node (you have to change function oneseg
    % and after that use this
%     [l , w] = size(A);
%     while (~isempty(find(A,1)))
%         a=find(~A,1);
%         x=rem(a,l);
%         y=floor(a/l)+1;
%         [seg{k},A]=oneseg(A,x,y,z);
%                 k=k+1;
%     end
    w=length(seg);
    for i=w:-1:1
        try 
            seg{i}(2,1);
        catch
            seg(i)=[];
        end
    end
    s=seg;
end