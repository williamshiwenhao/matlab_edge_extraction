clc;
clear all;
close all;
fileName = 'test.bmp';
img = imread(fileName);

%gray = rgb2gray(img);
% r=img(:, :, 1);
% g = img(:, :, 2);
% b = img(:, :, 3);
% 
% r = HpEnhance(r);
% g = HpEnhance(g);
% b = HpEnhance(b);
% 
% result(:, :, 1)=r;
% result(:, :, 2)=g;
% result(:, :, 3)=b;
gray = rgb2gray(img);
enhance = HpEnhance(gray);
imwrite(enhance, 'enhance.bmp');
figure,imshow(img);
figure,imshow(enhance);