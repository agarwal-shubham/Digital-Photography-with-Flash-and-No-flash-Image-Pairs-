function [ im ] = flashAdj( ima,imf, alpha )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    ya = rgb2ycbcr(ima);
    yf = rgb2ycbcr(imf);
    im = (1-alpha)*ya + alpha*yf;
    im = ycbcr2rgb(im);

end

