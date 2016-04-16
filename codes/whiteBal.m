function [ wb ] = whiteBal( imambient, imflash, opt )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    if opt == 1         %standard white balancing
        scaling = [255/246,255/169,255/87];
        imambient(:,:,1) = imambient(:,:,1)*scaling(1);
        imambient(:,:,2) = imambient(:,:,2)*scaling(2);
        imambient(:,:,3) = imambient(:,:,3)*scaling(3);
        wb = imambient;
    else
        [h,w,~] = size(imflash);
        imambientr = imambient(:,:,1);
        imambientg = imambient(:,:,2);
        imambientb = imambient(:,:,3);

        linflashr = histeq(imflash(:,:,1));
        linambientr = histeq(imambientr);
        linflashg = histeq(imflash(:,:,2));
        linambientg = histeq(imambientg);
        linflashb = histeq(imflash(:,:,3));
        linambientb = histeq(imambientb);

        albedor = linflashr - linambientr;
        albedog = linflashg - linambientg;
        albedob = linflashb - linambientb;

        thr1r = 0.02*(max(imambientr(:))-min(imambientr(:)));
        thr1g = 0.02*(max(imambientg(:))-min(imambientg(:)));
        thr1b = 0.02*(max(imambientb(:))-min(imambientb(:)));

        thr2r = 0.02*(max(albedor(:))-min(albedor(:)));
        thr2g = 0.02*(max(albedog(:))-min(albedog(:)));
        thr2b = 0.02*(max(albedob(:))-min(albedob(:)));

        albedor(albedor==0)=0.0001;
        albedog(albedog==0)=0.0001;
        albedob(albedob==0)=0.0001;
        Cr = imambientr./albedor;
        Cg = imambientg./albedog;
        Cb = imambientb./albedob;

        mr=0;mg=0;mb=0;Crmean=0;Cgmean=0;Cbmean=0;
        for i=1:h
            for j=1:w
                if  (abs(imambientr(i,j))>thr1r) && (albedor(i,j)>thr2r)
                   Crmean=Crmean+Cr(i,j);
                   mr=mr+1;
                end
                if  (abs(imambientg(i,j))>thr1g) && (albedog(i,j)>thr2g)
                   Cgmean=Cgmean+Cg(i,j);
                   mg=mg+1;
                end
                if  (abs(imambientb(i,j))>thr1b) && (albedob(i,j)>thr2b)
                   Cbmean=Cbmean+Cb(i,j);
                   mb=mb+1;
                end
            end
        end
        Crmean = Crmean/mr;
        Cgmean = Cgmean/mg;
        Cbmean = Cbmean/mb;

        wb = cat(3,imambientr/Crmean,imambientg/Cgmean,imambientb/Cbmean);
    end
end

