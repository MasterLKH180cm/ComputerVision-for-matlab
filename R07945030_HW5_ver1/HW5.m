% img = rgb2gray(imread('lena.jpg'));

kernel = [0,1,1,1,0;
          1,1,1,1,1;
          1,1,1,1,1;
          1,1,1,1,1;
          0,1,1,1,0];
kernel = logical(kernel);
%% dilation
dil = dilation(img,kernel);
%% erosion
ero = erosion(img,kernel);
%% opening
bin_open = erosion(dilation(img,kernel),kernel);
%% closing
bin_close = dilation(erosion(img,kernel),kernel);
%%
function [I] = dilation(img,kernel)
[a,b] = size(img);
[c,d] = size(kernel);
I = uint8(zeros(a+2*(c-1),b+2*(d-1)));
I2 = I;
I(c:end-c+1,d:end-d+1) = img;
[e,f] = size(I);
for i = 1:(e-c+1)
    for j = 1:(f-d+1)
        T = I(i:i+c-1,j:j+d-1);
        m = max(T(kernel));
        I2(i+(c-1)/2,j+(d-1)/2) = uint8(m);
    end
end
I = [];
I = I2(c:end-c+1,d:end-d+1);
end
function [I] = erosion(img,kernel)
[a,b] = size(img);
[c,d] = size(kernel);
I = uint8(zeros(a+2*(c-1),b+2*(d-1)));
I2 = I;
I(c:end-c+1,d:end-d+1) = img;
[e,f] = size(I);
for i = 1:(e-c+1)
    for j = 1:(f-d+1)
        T = I(i:i+c-1,j:j+d-1);
        m = min(T(kernel));
        I2(i+(c-1)/2,j+(d-1)/2) = uint8(m);
    end
end
I = [];
I = I2(c:end-c+1,d:end-d+1);
end

