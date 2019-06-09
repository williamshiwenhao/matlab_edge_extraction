clc;
clear all;
close all;
fileName = 'test.bmp';
img = imread(fileName);

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

%%
%edge
canny = edge(his, 'sobel',0.3);

figure,imshow(canny);

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
line = strel('line', 5, -40);
bw2 = imdilate(closed, line);
figure,imshow(bw2), title('imdilate with line');
%figure,imshow(A2);
