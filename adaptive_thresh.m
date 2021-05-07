function [GVOLUME,RVOLUME,Volume_ratio_R_G] = adaptive_thresh(green_volume,red_volume,green_sensitivity,red_sensitivity,name)
%UNTITLED Summary of this function goes here
close all;
%   Detailed explanation goes here
% adaptively threshold the image
%Calculate locally adaptive image threshold chosen using local first-order
... image statistics around each pixel. See adaptthresh for details. 
g_thresh = imbinarize(green_volume,'adaptive','ForegroundPolarity','bright','Sensitivity',green_sensitivity);
r_thresh = imbinarize(red_volume,'adaptive','ForegroundPolarity','bright','Sensitivity',red_sensitivity);

%Save Binary masks for viewing. 
save(name,'g_thresh','r_thresh');

%try regionprops for infomation extraction
Gstats = regionprops3(g_thresh,'Volume');
Rstats = regionprops3(r_thresh,'Volume');

%SUM THE TOTAL VOLUMES 
GVOLUME = sum(Gstats.Volume);
RVOLUME = sum(Rstats.Volume);

Volume_ratio_R_G = RVOLUME/GVOLUME;

% outputArg1 = inputArg1;
% outputArg2 = inputArg2;
end

