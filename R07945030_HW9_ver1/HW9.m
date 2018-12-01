img = double(imread('lena.bmp'));
%% Roberts
Rmask1 = [1,0;0,-1];
Rmask2 = [0,1;-1,0];
Rthreshold = 25;
edge_roberts = e2(img,Rmask1,Rmask2,Rthreshold);
%% prewitt
Pmask1 = [-1,-1,-1;0,0,0;1,1,1];
Pmask2 = [-1,0,1;-1,0,1;-1,0,1];
Pthreshold = 90;
edge_prewitt = e3(img,Pmask1,Pmask2,Pthreshold);
%% sobel
Smask1 = [-1,-2,-1;0,0,0;1,2,1];
Smask2 = [-1,0,1;-2,0,2;-1,0,1];
Sthreshold = 120;
edge_sobel = e3(img,Smask1,Smask2,Sthreshold);
%% Frei and Chen
FCmask1 = [-1,-(2^0.5),-1;0,0,0;1,(2^0.5),1];
FCmask2 = [-1,0,1;-(2^0.5),0,(2^0.5);-1,0,1];
FCthreshold = 100;
edge_FC = e3(img,FCmask1,FCmask2,FCthreshold);

%% Kirsch
mask1 = [-3,-3,5;
         -3,0,5;
         -3,-3,5];
mask2 = [-3,5,5;
         -3,0,5;
         -3,-3,-3];
mask3 = [5,5,5;
         -3,0,-3;
         -3,-3,-3];
mask4 = [5,5,-3;
         5,0,-3;
         -3,-3,-3];

Kthreshold = 500;
edge_K = e4(img,mask1,mask2,mask3,mask4,Kthreshold);
%% robinson
mask1 = [-1,0,1;
         -2,0,2;
         -1,0,1];
mask2 = [0,1,2;
         -1,0,1;
         -2,-1,0];
mask3 = [1,2,1;
         0,0,0;
         -1,-2,-1];
mask4 = [2,1,0;
         1,0,-1;
         0,-1,-2];

ROBINSONthreshold = 130;
edge_ROBINSON = e4(img,mask1,mask2,mask3,mask4,ROBINSONthreshold);
%% Nevatia & Babu
mask1 = [100,100,100,100,100;
         100,100,100,100,100;
         0,0,0,0,0;
         -100,-100,-100,-100,-100;
         -100,-100,-100,-100,-100];
mask2 = [100,100,100,100,100;
         100,100,100,78,-32;
         100,92,0,-92,-100;
         32,-78,-100,-100,-100;
         -100,-100,-100,-100,-100];
mask3 = mask2';
mask4 = [-100,-100,0,100,100;
         -100,-100,0,100,100;
         -100,-100,0,100,100;
         -100,-100,0,100,100;
         -100,-100,0,100,100;];
mask5 = [-100,32,100,100,100;
         -100,-78,92,100,100;
         -100,-100,0,100,100;
         -100,-100,-92,78,100;
         -100,-100,-100,-32,100;];
mask6 = [100,100,100,100,100;
         -32,78,100,100,100;
         -100,-92,0,92,100;
         -100,-100,-100,-78,32;
         -100,-100,-100,-100,-100];
nbthreshold = 37000;
edge_nb = e5(img,mask1,mask2,mask3,mask4,mask5,mask6,nbthreshold);
%% plot
figure,imshow(uint8(edge_roberts));
figure,imshow(uint8(edge_prewitt));
figure,imshow(uint8(edge_sobel));
figure,imshow(uint8(edge_FC));
figure,imshow(uint8(edge_K));
figure,imshow(uint8(edge_ROBINSON));
figure,imshow(uint8(edge_nb));
%% height and width = 2
function [output] = e2(img,mask1,mask2,threshold)
    [a,b] = size(img);
    m1 = zeros([a-1,b-1]);
    m2 = m1;
    for i = 1:a-1
        for j = 1:b-1
            m1(i,j) = (sum(sum(img(i:i+1,j:j+1).*mask1))).^2;
            m2(i,j) = (sum(sum(img(i:i+1,j:j+1).*mask2))).^2;
        end
    end

    m3 = uint8(sqrt(m1+m2));
    t = m3 < threshold;
    output = zeros(size(t));
    output(t)=255;
    output(~t)=0;
end
%% height and width = 3
function [output] = e3(img,mask1,mask2,threshold)
    [a,b] = size(img);
    m1 = zeros([a-2,b-2]);
    m2 = m1;
    for i = 1:a-2
        for j = 1:b-2
            m1(i,j) = (sum(sum(img(i:i+2,j:j+2).*mask1))).^2;
            m2(i,j) = (sum(sum(img(i:i+2,j:j+2).*mask2))).^2;
        end
    end

    m3 = uint8(sqrt(m1+m2));
    t = m3 < threshold;
    output = zeros(size(t));
    output(t)=255;
    output(~t)=0;
end
%% Kirsch
function [output] = e4(img,mask1,mask2,mask3,mask4,threshold)
    [a,b] = size(img);
    
    temp = zeros([1,8]);
    m = zeros([a-2,b-2]);
    for i = 1:a-2
        for j = 1:b-2
            temp(1) = (sum(sum(img(i:i+2,j:j+2).*mask1)));
            temp(2) = (sum(sum(img(i:i+2,j:j+2).*mask2)));
            temp(3) = (sum(sum(img(i:i+2,j:j+2).*mask3)));
            temp(4) = (sum(sum(img(i:i+2,j:j+2).*mask4)));
            temp(5:8) = -1*temp(1:4);
            m(i,j) = max(temp);
        end
    end

    t = m < threshold;
    output = zeros(size(t));
    output(t)=255;
    output(~t)=0;
end
%% nb
function [output] = e5(img,mask1,mask2,mask3,mask4,mask5,mask6,threshold)
    [a,b] = size(img);
    
    temp = zeros([1,12]);
    m = zeros([a-4,b-4]);
    for i = 1:a-4
        for j = 1:b-4
            temp(1) = (sum(sum(img(i:i+4,j:j+4).*mask1)));
            temp(2) = (sum(sum(img(i:i+4,j:j+4).*mask2)));
            temp(3) = (sum(sum(img(i:i+4,j:j+4).*mask3)));
            temp(4) = (sum(sum(img(i:i+4,j:j+4).*mask4)));
            temp(5) = (sum(sum(img(i:i+4,j:j+4).*mask5)));
            temp(6) = (sum(sum(img(i:i+4,j:j+4).*mask6)));
            temp(7:12) = -1*temp(1:6);
            m(i,j) = max(temp);
        end
    end

    t = m < threshold;
    output = zeros(size(t));
    output(t)=255;
    output(~t)=0;
end
