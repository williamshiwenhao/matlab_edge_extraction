clc;
clear all;
close all;
fileName = 'test.bmp';
img = imread(fileName);
%%
rustColor=[70,62,59];
th = 20;
mask = zeros(size(img,1), size(img,2));
dimg = double(img);
diff(:,:,1) =  dimg(:,:,1)- rustColor(1);
diff(:,:,2) = dimg(:,:,2) - rustColor(2);
diff(:,:,3) = dimg(:,:,3) - rustColor(3);
total = sum(diff.^2,3);
mask(total < th) = 1;
figure,imshow(mask);


%%
%High pass enhancement
yuv = rgb2ycbcr(img);
y = yuv(:, :, 1);
gray = rgb2gray(img);
enhance = HpEnhance(gray);
imwrite(enhance, 'enhance.bmp');
%figure,imshow(img);
%figure,imshow(enhance);

%%
%histogram equalization
%figure, imhist(enhance);
oldHis = imhist(enhance);
oldHis = oldHis / max(oldHis);
lowBound = 30;
highBound = 34;
newHis = oldHis;
dark = sum(newHis(1:lowBound));
light = sum(newHis(highBound:end));
newHis = zeros((highBound- lowBound)+3, 1);
newHis(1) = sum(oldHis(1:lowBound-1));
newHis(end)=sum(oldHis(highBound+1:end));
newHis(2:end-1) = oldHis(lowBound:highBound);
his = histeq(enhance, newHis);
%his = histeq(his);
figure,imshow(his);
his(mask==1)=255;
figure,imshow(his);

%%
%edge
canny = edge(his, 'sobel',0.3);

%figure,imshow(canny);

%line
% f1 = [-1,-1,-1;2,2,2;-1,-1,-1];
% f2 = [-1,-1,2;-1,2,-1;2,-1,-1];
% f3 = [-1,2,-1;-1,2,-1;-1,2,-1];
% f4 = [2,-1,-1;-1,2,-1;-1,-1,2];
% r1=imfilter(double(his),f1);
% r2 = imfilter(double(his), f2);
% r3 = imfilter(double(his), f3);
% r4 = imfilter(double(his), f4);
% r = r1+r2+r3+r4;
% T = -500;
% r(r>T)=0;
% r(r<T)=255;
% imshow(r)

canny = bwmorph(canny, 'spur');
canny = bwmorph(canny, 'clean');

%��ͨ����
L = bwlabel(canny);
num = max(max(L));
thX = 10;
thY = 10;
mins = canny;
for ii=1:num
    [x,y] = find(L==ii);
    diffX = max(x)-min(x);
    diffY = max(y)-min(y);
    if (diffX<=thX && diffY<=thY) 
        mins(x,y)=0;
    end
end
figure,imshow(mins);
closed = bwmorph(mins, 'close');
figure,imshow(closed);title('close');

%%
%take img to 3 parts
%150-200 200-400 400-500
head = closed(:,1:156);
leftHead = closed(:, 157:199);
left = closed(:,200:300);
middle = closed(:,300:400);
right = closed(:,400:530);
tail = closed(:,531:end);
%left head
line = strel('line', 5,90);
leftHead = imdilate(leftHead, line);
%left
line = strel('line',12,10);
left = imdilate(left, line);
%middle
%line = strel('line',10,5);
%middle = imdilate(middle, line);
%right
line = strel('line',8,-40);
right = imdilate(right, line);


together = [head, leftHead, left, middle, right, tail];
together = bwmorph(together, 'close');
figure,imshow(together);title('Together');
%%
%
%skel = bwmorph(together, 'remove');
skel = bwmorph(together, 'skel', inf);
skel = bwmorph(skel, 'spur',inf);
figure, imshow(skel);title('skel');

%%
%
L = bwlabel(skel);
num = max(max(L));
thX = 200;
thY = 100;
mins = skel;
for ii=1:num
    [y,x] = find(L==ii);
    diffX = max(x)-min(x);
    diffY = max(y)-min(y);
    if (diffX<=thX || diffY<=thY) 
        mins(y,x)=0;
    end
end
figure,imshow(mins);title('mins');