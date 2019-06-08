function [ filter_image1 ] = HpEnhance( Original_image )
%HpEnhance Use high pass filter to enhance picture
[len,wid]=size(Original_image);
Original_image=im2double(Original_image);
g=fft2(Original_image); %��ά����Ҷ�任
g=fftshift(g);  %Ƶ��

n1=2;   %������˹�˲�������Ϊ2
D0=0.05*len;  %��ֹƵ��5%��ͼ����
[M,N]=size(g);
m=fix(M/2);
n=fix(N/2);
s1 = zeros(M, N);
for i=1:M
   for j=1:N
        D=sqrt((i-m)^2+(j-n)^2);
        h1=1/(1+(D0/D)^(2*n1));   %�����ͨ�˲������ݺ���
        h2=0.5+2*h1;    %���high-frequency emphasis����a=0.5,b=2.0
        s1(i,j)=h2*g(i,j);  %����Ƶ��˲�������ԭͼ��
   end
end

filter_image1=im2uint8(real(ifft2(ifftshift(s1))));  %����Ҷ���任

end

