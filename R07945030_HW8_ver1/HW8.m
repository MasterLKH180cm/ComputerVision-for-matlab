img = double(imread('lena.bmp'));
%% gausian noise
gau_noise = randn(size(img));
% gau_img10 = uint8(img + 10 * gau_noise);
% gau_img30 = uint8(img + 30 * gau_noise);
gau_img10 = img + 10 * gau_noise;
gau_img30 = img + 30 * gau_noise;
%% salt and pepper noise
s_and_p_noise = rand(size(img));
threshold_1 = 0.1;
threshold_2 = 0.05;
sp_img_1 = img;
sp_img_1(s_and_p_noise < threshold_1) = 0;
sp_img_1(s_and_p_noise > 1 - threshold_1) = 255;
sp_img_2 = img;
sp_img_2(s_and_p_noise < threshold_2) = 0;
sp_img_2(s_and_p_noise > 1 - threshold_2) = 255;
%% box filter 3X3 & 5X5
box_filter3X3 = ones(3) / 9;
box_filter5X5 = ones(5) / 25;
box_gau10_3X3 = box_filt(gau_img10,box_filter3X3);
box_gau30_3X3 = box_filt(gau_img30,box_filter3X3);
box_sp1_3X3 = box_filt(sp_img_1,box_filter3X3);
box_sp2_3X3 = box_filt(sp_img_2,box_filter3X3);

box_gau10_5X5 = box_filt(gau_img10,box_filter5X5);
box_gau30_5X5 = box_filt(gau_img30,box_filter5X5);
box_sp1_5X5 = box_filt(sp_img_1,box_filter5X5);
box_sp2_5X5 = box_filt(sp_img_2,box_filter5X5);
%% median filter 3X3 & 5X5
median_filter3X3 = ones(3);
median_filter5X5 = ones(5);

median_gau10_3X3 = median_filt(gau_img10,median_filter3X3);
median_gau30_3X3 = median_filt(gau_img30,median_filter3X3);
median_sp1_3X3 = median_filt(sp_img_1,median_filter3X3);
median_sp2_3X3 = median_filt(sp_img_2,median_filter3X3);

median_gau10_5X5 = median_filt(gau_img10,median_filter5X5);
median_gau30_5X5 = median_filt(gau_img30,median_filter5X5);
median_sp1_5X5 = median_filt(sp_img_1,median_filter5X5);
median_sp2_5X5 = median_filt(sp_img_2,median_filter5X5);
%% openning & closing
kernel = [0,1,1,1,0;
          1,1,1,1,1;
          1,1,1,1,1;
          1,1,1,1,1;
          0,1,1,1,0];
kernel = logical(kernel);
oc_gau10 = close(open(gau_img10,kernel),kernel);
oc_gau30 = close(open(gau_img30,kernel),kernel);
oc_sp1 = close(open(sp_img_1,kernel),kernel);
oc_sp2 = close(open(sp_img_2,kernel),kernel);
%% closing & openning
co_gau10 = open(close(gau_img10,kernel),kernel);
co_gau30 = open(close(gau_img30,kernel),kernel);
co_sp1 = open(close(sp_img_1,kernel),kernel);
co_sp2 = open(close(sp_img_2,kernel),kernel);

%% box function
function [output] = box_filt(img,filter)
    [a,b] = size(img);
    output = img;
    [c,d] = size(filter);
    img = [zeros((c-1)/2,b);img;zeros((c-1)/2,b)];
    img = [zeros(a+c-1,(d-1)/2),img,zeros(a+c-1,(d-1)/2)];
    for i = 1:a
        for j = 1:b
            output(i,j) = sum(sum(img(i:i+c-1,j:j+d-1).*filter));
        end
    end
    output = uint8(output);
end
%% median function
function [output] = median_filt(img,filter)
    [a,b] = size(img);
    output = img;
    [c,d] = size(filter);
    filter = logical(filter);
    img = [zeros((c-1)/2,b);img;zeros((c-1)/2,b)];
    img = [zeros(a+c-1,(d-1)/2),img,zeros(a+c-1,(d-1)/2)];
    for i = 1:a
        for j = 1:b
            temp = img(i:i+c-1,j:j+d-1);
            temp = sort(temp(filter));
            output(i,j) = temp((length(temp)+1)/2);
        end
    end
    output = uint8(output);
end

%% opening
function [I] = open(img,kernel)
    I = erosion(dilation(img,kernel),kernel);
end
%% closing
function [I] = close(img,kernel)
    I = dilation(erosion(img,kernel),kernel);
end
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
