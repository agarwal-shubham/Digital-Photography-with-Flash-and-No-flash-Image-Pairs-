function [ Ajoint, Abase, Fbase ] = bilateral( imflash, imambient)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    
    sigmag = 5;
    ws = 11;
    sigmab1 = (max(imambient(:)) - min(imambient(:)))*(255/10);
    gauss_mask = fspecial('gaussian',ws, sigmag);
    
    bias = floor(ws/2);
    flashpad = padarray(imflash,[bias bias],'replicate');
    ambientpad = padarray(imambient,[bias bias],'replicate');

    [h,w] = size(imflash);
    Ajoint = zeros(h,w);
    Abase = zeros(h,w);
    Fbase = zeros(h,w);
    for i = 1+bias:h+bias
        for j = 1+bias:w+bias
            amb_mask = ambientpad(i-bias:i+bias,j-bias:j+bias);
            flash_mask = flashpad(i-bias:i+bias,j-bias:j+bias);
            flash_diffmask = flash_mask-flashpad(i,j);
            amb_diffmask = amb_mask-ambientpad(i,j);
            bil_mask_flash = exp(-1*((flash_diffmask/sigmab1).^2)/(2*(sigmab1^2)));      %/(sqrt(2*pi)*sigmab); normalizstion term kindof
            bil_mask_amb = exp(-1*((amb_diffmask/sigmab1).^2)/(2*(sigmab1^2)));
            filt_mask_flash = bil_mask_flash.*gauss_mask;
            norm_term_flash = sum(filt_mask_flash(:));
            filt_mask_amb = bil_mask_amb.*gauss_mask;
            norm_term_amb = sum(filt_mask_amb(:));
            Ajoint_mask = (amb_mask.*filt_mask_flash)/norm_term_flash;
            Abase_mask = (amb_mask.*filt_mask_amb)/norm_term_amb;
            Fbase_mask = (flash_mask.*filt_mask_flash)/norm_term_flash;
            Ajoint(i-bias,j-bias) = sum(Ajoint_mask(:));
            Abase(i-bias,j-bias) = sum(Abase_mask(:));
            Fbase(i-bias,j-bias) = sum(Fbase_mask(:));
        end
        %i
    end
end

