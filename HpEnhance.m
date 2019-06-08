function [ filter_image1 ] = HpEnhance( Original_image )
%HpEnhance Use high pass filter to enhance picture
[len,wid]=size(Original_image);
Original_image=im2double(Original_image);
g=fft2(Original_image); %二维傅立叶变换
g=fftshift(g);  %频移

n1=2;   %巴特沃斯滤波器阶数为2
D0=0.05*len;  %截止频率5%的图像宽度
[M,N]=size(g);
m=fix(M/2);
n=fix(N/2);
s1 = zeros(M, N);
for i=1:M
   for j=1:N
        D=sqrt((i-m)^2+(j-n)^2);
        h1=1/(1+(D0/D)^(2*n1));   %计算高通滤波器传递函数
        h2=0.5+2*h1;    %设计high-frequency emphasis其中a=0.5,b=2.0
        s1(i,j)=h2*g(i,j);  %用设计的滤波器处理原图像
   end
end

filter_image1=im2uint8(real(ifft2(ifftshift(s1))));  %傅里叶反变换

end

