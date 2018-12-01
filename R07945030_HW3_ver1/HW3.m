img = rgb2gray(imread('lena.jpg'));
[a,b] = size(img);
figure,imshow(img);
hist = zeros(1,256);
acc = hist;
hist2 = hist;
for i = 0:255
   hist(i+1) = length(find(img == i));
end
for i = 0:255
   acc(i+1) = sum(hist(1:i));
end
img2 = zeros(a,b);
for i = 0:255
   img2(img == i) = 255*(acc(i+1)/(a*b));
end
figure,imshow(uint8(img2));
figure,bar(hist);
img2 = round(img2);
for i = 0:255
   hist2(i+1) = length(find(img2 == i));
end
figure,bar(hist2);