img = rgb2gray(imread('lena.jpg'));

%% binarize
binarized = img;
map = (binarized <= 127);
binarized(map) = 0;
binarized(~map) = 255;
figure,imshow(binarized);
%% histogram
temp2 = img;
hist = zeros(0,256);
for i = 0:255
   hist(i+1) = length(find(temp2 == i));
end
figure,bar(hist);
%% Efficient Run-Length Implementation of the Local Table Method
temp3 = zeros(size(binarized));
run_table = find(binarized == 255);
number_loop = length(run_table);
number_run = 1;
for i = 1:number_loop
    temp3(run_table(i)) = number_run;
    if  i ~= number_loop
        if (run_table(i+1) - run_table(i) ~= 1) || (floor(mod(run_table(i),512)) == 0) || (floor(run_table(i)/512) ~= floor(run_table(i+1)/512))
            number_run = number_run + 1;
        end
    end
end
table = [];
for i = 1:number_run
    r = find(temp3 == i);
    table = [table;min(r),max(r),i];
end
table(:,4) = floor(table(:,1)/512)+1;
table(:,1:2) = floor(mod(table(:,1:2),512));
%% top down
for i = 1:512
    runs_current = find(table(:,4) == i);
    runs_next = find(table(:,4) == i + 1);
    number_runs_current = length(runs_current);
    number_runs_next = length(runs_next);
    current_row = table(runs_current,:);
    next_row = table(runs_next,:);
    for j = 1:number_runs_current
        for k = 1:number_runs_next
           if ((current_row(j,2) >= next_row(k,1)) && (next_row(k,1) >= current_row(j,1))) || ((current_row(j,2) >= next_row(k,1)) && (next_row(k,2) >= current_row(j,1)))
               next_row(k,3) = current_row(j,3);
           end
        end
    end
    table(runs_current,:) = current_row;
    table(runs_next,:) = next_row;
end
%% bottom up
for i = 512:2
    runs_current = find(table(:,4) == i);
    runs_next = find(table(:,4) == i - 1);
    number_runs_current = length(runs_current);
    number_runs_next = length(runs_next);
    current_row = table(runs_current,:);
    next_row = table(runs_next,:);
    for j = 1:number_runs_current
        for k = 1:number_runs_next
           if ((current_row(j,2) >= next_row(k,1)) && (next_row(k,1) >= current_row(j,1))) || ((current_row(j,2) >= next_row(k,1)) && (next_row(k,2) >= current_row(j,1)))
               next_row(k,3) = current_row(j,3);
           end
        end
    end
    table(runs_current,:) = current_row;
    table(runs_next,:) = next_row;
end
%% relabel
a = unique(table(:,3));
loop = length(a);
for i = 1:loop
    table(table(:,3) == a(i),3) = i;
end
%% calculate area
area = zeros(loop,1);
for i = 1:loop
        area(i) = sum(table(table(:,3) == i,2) - table(table(:,3) == i,1)) + sum(table(:,3) == i);
end
s = area;
s(s<500) = [];

%% centroid
loop = length(s);
for i = 1:loop
   index(i) = find(area == s(i));
   t = table(table(:,3)==index(i),:);
   tt = zeros(512);
   for j = 1:length(t(:,1))
      tt(t(j,1):t(j,2),t(j,4)) = 255; 
   end
   
   y = 1:512;
   x = 1:512;
   cy(i) = (y*sum(tt,1)')/sum(sum(tt));
   cx(i) = (x*sum(tt,2))/sum(sum(tt));
end
figure,imshow(binarized)
hold on,plot(cy,cx,'+','MarkerSize' ,20);
%% bounding box
for i = 1:loop
   t = table(table(:,3)==find(area == s(i)),:);
   pos = [min(t(:,4)) ,min(min(t(:,1:2))) ,range(t(:,4))+1 ,range([t(:,1);t(:,2)]+1)];
   h = rectangle('Position',pos,'EdgeColor','r','LineWidth',2 );
end
