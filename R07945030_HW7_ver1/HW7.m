clc,clear all;
img = (imread('lena.bmp'));

%% binarize
binarized = img;
map = (binarized < 128);
binarized(map) = 0;
binarized(~map) = 255;
%% down sampling
for i = 0:63
    for j = 0:63
        ds_img(i+1,j+1) = binarized(8*i+1,8*j+1);
    end
end
%% border interior
bi_img = bi(ds_img);
%% pair relationship
pr_img = pr(bi_img,ds_img);
%% thinning
output = uint8(thinning(ds_img));
%% border interior
function [bi_img] = bi(img)
    [a,b] = size(img);
    temp = zeros(a+2,b+2);
    temp(2:end-1,2:end-1) = img;
    idx = find(temp == 255);
    y = mod(idx,a+2);
    y(y == 0) = a + 2;
    x = floor((idx-y)/(a+2))+1;
    for i = 1:length(idx)
        bi_mark = logical(temp(y(i)-1:y(i)+1,x(i)-1:x(i)+1));
        if (bi_mark(1,2)==1)&&(bi_mark(2,1)==1)&&(bi_mark(3,2)==1)&&(bi_mark(2,3)==1&&(bi_mark(2,2)==1))
%         if isequal(bi_mark,ones(3))
            bi_img(y(i),x(i)) = "i";
        else
            bi_img(y(i),x(i)) = "b";
        end
    end
    bi_img(:,1) = [];
    bi_img(1,:) = [];
end
%%
function [pr_img] = pr(bi_img,ds_img)
    [a,b] = size(bi_img);
    temp = strings(a+2,b+2);
    temp(2:end-1,2:end-1) = bi_img;
    temp(ismissing(temp)) = '';
    idx = find(~(temp == ''));
    y = mod(idx,a+2);
    y(y == 0) = a + 2;
    x = floor((idx-y)/(a+2))+1;
    pr_img = strings(size(temp));
    yokoi_connectivity_matrix = (yokoi(ds_img));
    for i = 1:length(idx)
        mark = yokoi_connectivity_matrix(y(i)-1:y(i)+1,x(i)-1:x(i)+1);
        cons = mark(logical([0,1,0;1,0,1;0,1,0]));%4
        cons = length(find(cons =='1'));
        if (temp(y(i),x(i)) == 'b') && cons >= 1
            pr_img(y(i),x(i)) = 'p';
        else
            pr_img(y(i),x(i)) = 'q';
        end
    end
    pr_img(:,1) = [];
    pr_img(:,end) = [];
    pr_img(1,:) = [];
    pr_img(end,:) = [];
end
%%
function [ds_img] = thinning(ds_img)
    cons = 0;
    while 1
        cons = cons+1
        pr_img = pr(bi(ds_img),ds_img);
        [a,b] = size(ds_img);
        ds_temp = zeros(a+2,b+2);
        pr_temp = strings(size(ds_temp));
        ds_temp(2:end-1,2:end-1) = ds_img;
        pr_temp(2:end-1,2:end-1) = pr_img;
        
        
        idx = find(ds_temp == 255);
        y = mod(idx,a+2);
        y(y == 0) = a + 2;
        x = ((idx-y)/(a+2))+1;
        [y,index] = sort(y);
        x = x(index);
        for i = 1:length(idx)
            if isequal(pr_temp(y(i),x(i)),"p") && (count_yokoi(ds_temp(y(i)-1:y(i)+1,x(i)-1:x(i)+1)))
                ds_temp(y(i),x(i)) = 0;
            end
        end


%         for y = 2:a+1
%             for x = 2:b+1
%                 if isequal(pr_temp(y,x),"p") && (count_yokoi(ds_temp(y-1:y+1,x-1:x+1)))
%                     ds_temp(y,x) = 0;
%                 end
%             end
%         end
        ds_temp(1,:) = [];
        ds_temp(end,:) = [];
        ds_temp(:,1) = [];
        ds_temp(:,end) = [];
        if (ds_img == ds_temp)
            break;
        else
            ds_img = ds_temp;
        end
    end
    
end
%%
function [removable] = count_yokoi(block)
    q = 0;
    temp = zeros(3);
    for i = 1:4
        if (block(2,2) == block(2,3)) && ((block(1,3) ~= block(2,2)) || (block(1,2) ~= block(2,2)))
            q = q + 1;
        end
        temp(1:3,3) = block(1,1:3);
        temp(1:3,2) = block(2,1:3);
        temp(1:3,1) = block(3,1:3);
        block = temp;
    end
    if q == 1
        removable = true;
    else
        removable = false;
    end
end
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