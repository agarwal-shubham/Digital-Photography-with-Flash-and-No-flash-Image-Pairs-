clear all; close all; clc;
% imf = im2double(imread('./../main/mike_02_flash.jpg'));
% ima = im2double(imread('./../main/mike_01_no_flash.jpg'));
% imf = im2double(imread('./../main/00_02_aligned_face_flash.jpg'));
% ima = im2double(imread('./../main/00_01_aligned_face_no_flash.jpg'));
% imf = im2double(imread('./../main/friend_02_flash.jpg'));
% ima = im2double(imread('./../main/friend_01_no_flash.jpg'));
imf = im2double(imread('./../main/esther_02_flash.jpg'));
ima = im2double(imread('./../main/esther_01_no_flash.jpg'));
[h,w,~] = size(imf);
yf = rgb2ycbcr(imf);
ya = rgb2ycbcr(ima);
hsvf = rgb2hsv(imf);

R = yf(:,:,3)-ya(:,:,3);
R=R-min(R(:));
R=R/max(R(:));

flag = zeros(size(R));
flag2 = zeros(size(R));
Rm = mean(R(:));
Rdev = std(R(:));
thr = max(0.6,Rm+(Rdev*3));

flag(R>thr) = 1;
flag(ya(:,:,1)>=0.5) = 0;

flag = imfill(flag);
se = strel('disk',2);
se2 = strel('disk',2);
flag = imerode(flag,se);
flag = imdilate(flag,se2);



[y,x]=find(flag==1);    % detected  pixels
im = imf;


bias=[26,49];
for i=1:size(y,1)
    f=0;
    if y(i)<50 || x(i)<50 || x(i)>w-50 || y(i)>h-50
        f=1;
    else
        mask = flag(y(i)-bias(2):y(i)+bias(2),x(i)-bias(2):x(i)+bias(2));
        mask(23:end-23,23:end-23)=0;
        if any(mask(:)==1)==1
            f=1;
        end
    end
    if f==0
        flag2(y(i),x(i))=1;
        im(y(i),x(i),1) = 0.8*(0.299*imf(y(i),x(i),1) + 0.587*imf(y(i),x(i),2) + 0.114*imf(y(i),x(i),3));
    end
end


figure, imshow(im);
figure, imshow(imf);
figure, imshow(flag2);

