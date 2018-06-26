function [s,A] = oneseg(A,x,y,z)
% On matrix A it make a segment from point x and y to stop with 
k2=1;
[l,w]=size(A);
seg{k2,1}=x;
seg{k2,2}=y;
       while (((A(x+1,y)==0)||(A(x-1,y)==0)||(A(x,y-1)==0)||(A(x,y+1)==0))&&(intersectfind(z,[x+1,y])~=1)&&(intersectfind(z,[x-1,y])~=1)&&(intersectfind(z,[x,y-1])~=1)&&(intersectfind(z,[x,y+1])~=1))
            if A(x+1,y)==0
                A(x,y)=1;
                x=x+1;
                k2=k2+1;
                seg{k2,1}=x;
                seg{k2,2}=y;
            elseif A(x-1,y)==0
                A(x,y)=1;
                x=x-1;
                k2=k2+1;
                seg{k2,1}=x;
                seg{k2,2}=y;
            elseif A(x,y+1)==0
                A(x,y)=1;
                y=y+1;
                k2=k2+1;
                seg{k2,1}=x;
                seg{k2,2}=y;
            elseif A(x,y-1)==0
                A(x,y)=1;
                y=y-1;
                k2=k2+1;
                seg{k2,1}=x;
                seg{k2,2}=y;
            end
            if ((x<=1)||(x>=l)||(y<=1)||(y>=w))
                break
            end
       end
A(x,y)=1;
s=seg;
end