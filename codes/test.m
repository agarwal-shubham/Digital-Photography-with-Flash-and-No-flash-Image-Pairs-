%clear all; close all; clc;

imflash = im2double(imread('./../flash/helmet.06.f1.jpg'));
imambient = im2double(imread('./../flash/helmet.02.fadjust0.0.jpg'));
figure, imshow(flashAdj(imambient,imflash,1.25));