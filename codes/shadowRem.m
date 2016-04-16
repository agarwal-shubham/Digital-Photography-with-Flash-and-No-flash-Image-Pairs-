function [ flag ] = shadowRem( imflash, imambient )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

%     linflash = histeq(rgb2gray(imflash));
%     linambient = histeq(rgb2gray(imambient));
    % linflash = imadjust(rgb2gray(imflash));
    % linambient = imadjust(rgb2gray(imambient));

    linflash = 0.299*imflash(:,:,1) + 0.587*imflash(:,:,2) + 0.114*imflash(:,:,3);
    linambient = 0.299*imambient(:,:,1) + 0.587*imambient(:,:,2) + 0.114*imambient(:,:,3);
    mask = linflash - linambient;
    flag = zeros(size(mask));
    [hist,~] = imhist(mask,256);
    hist = hist/numel(mask);
    gaus = fspecial('gaussian',[1 10],2);
    hist = conv(hist,gaus,'same');

    thr1 = -0.05;
    thr2 = -0.2;
    flag(mask>thr2 & mask<thr1)=1;
    flag(mask>0.65 & mask<0.7)=1;
    rang = 0.95*(max(linflash(:))-min(linflash(:)));
    flag(linflash>rang)=1;

    se1 = strel('disk',2);
    se2 = strel('disk',6);
    se3 = strel('disk',4);
    flag = imerode(flag,se1);
    flag = imfill(flag,'holes');
    flag = imdilate(flag,se2);
    flag = imerode(flag,se3);
    H=fspecial('gaussian',3,3);
    flag = imfilter(flag,H);
end

