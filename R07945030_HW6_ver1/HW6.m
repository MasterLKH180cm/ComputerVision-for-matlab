clear all;
clc
img = rgb2gray(imread('lena.jpg'));

%% binarize
binarized = img;
map = (binarized <= 127);
binarized(map) = 0;
binarized(~map) = 255;
% figure,imshow(binarized);
%% down sampling
for i = 0:63
    for j = 0:63
        ds_img(i+1,j+1) = binarized(8*i+1,8*j+1);
    end
end
%% yokoi connectivity number
yokoi_connectivity_matrix = (yokoi(ds_img));



function [yokoi_connectivity_matrix] = yokoi(img)
    [a,b] = size(img);
    temp = zeros(a+2,b+2);
    yokoi_connectivity_matrix = strings(size(temp));
    temp(2:end-1,2:end-1) = img;
    idx = find(temp == 255);
    y = mod(idx,a+2);
    x = ((idx-y)/(a+2))+1;
    for i = 1:length(idx)
        yokoi_connectivity_matrix(y(i),x(i)) = (c_yokoi(temp(y(i)-1:y(i)+1,x(i)-1:x(i)+1)));
    end
    yokoi_connectivity_matrix(1,:) = [];
    yokoi_connectivity_matrix(end,:) = [];
    yokoi_connectivity_matrix(:,1) = [];
    yokoi_connectivity_matrix(:,end) = [];
    yokoi_connectivity_matrix(yokoi_connectivity_matrix == " ") = "  ";
end
function [number] = c_yokoi(block)
    q = 0;
    r = 0;
    s = 0;
    temp = zeros(3);
    for i = 1:4
        if (block(2,2) == block(2,3)) && ((block(1,3) ~= block(2,2)) || (block(1,2) ~= block(2,2)))
            q = q + 1;
        end
        if (block(2,2) == block(2,3)) && ((block(1,3) == block(2,2)) && (block(1,2) == block(2,2)))
            r = r + 1;
        end
        if (block(2,2) ~= block(2,3))
            s = s + 1;
        end
        temp(1:3,3) = block(1,1:3);
        temp(1:3,2) = block(2,1:3);
        temp(1:3,1) = block(3,1:3);
        block = temp;
    end
    if r == 4
        number = 5;
    else
       number = q; 
    end
end