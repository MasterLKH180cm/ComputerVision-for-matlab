img = imread('lena.jpg');
img(:,:,1:2) = [];
figure,imshow(img);
[row, col] = size(img);
%% image upside_down
img_upside_down = img;
for i = 1:row/2
   temp = img_upside_down(row+1-i,:);
   img_upside_down(row+1-i,:) = img_upside_down(i,:);
   img_upside_down(i,:) = temp;
end
figure,imshow(uint8(img_upside_down));
%% image rightside_left
img_rightside_left = img;
for i = 1:col/2
   temp = img_rightside_left(:,col+1-i);
   img_rightside_left(:,col+1-i) = img_rightside_left(:,i);
   img_rightside_left(:,i) = temp;
end
figure,imshow(uint8(img_rightside_left));
%% image diagnal
diagnal = zeros(size(img));
for i = 1:512
   for j = 1:512
       diagnal(i,j) = img(j,i);
   end
end
figure,imshow(uint8(diagnal));
