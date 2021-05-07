function [GVOLUME,RVOLUME,Volume_ratio_R_G,GreenMask, RedMask,greenTherhold,redThreshold] = Otsu_thresh(green_volume,red_volume,name)
%  Performs a global threshold on volumes using Otsu’s method
% 
%  Function takes in two parameters. The green and red volumes which
%  are deinterleaved in the main function and creates two 3D binary volumes 
%  which are passed to regionprops3. From regionprops3 the number of voxels
%  is summed to determine the total number of voxels in the volume. 
% 
%  Returns the 3D binary masks created for each channel, the ratio of the two
%  masks and the thresholds determined by Otsu’s Method which were used to 
%  create the 3D masks. The function will also display each channel’s volume
%  using MATLAB's labelvolshow function using the threshold determined by
%  Otsu's method along with the histogram showing the threshold. This is
%  handy if you use MATLABs publishing option as it will snap a photo of the
%  results for each image processed. Lastly the 3D binary mask is saved to
%  the current directory as a .mat file for viewing after processing which 
%  can be done by using the function DisplayVolumes.
 
%close any open figures 
close all; 

%Format string for title of histograms used to show thresholds from Otsu results
formatSpecG = "%s - Histogram Green Voxel Values";
formatSpecR = "%s - Histogram Red Voxel Values";
Ghist_Header = sprintf(formatSpecG,name);
Rhist_Header = sprintf(formatSpecR,name);

formatSpecGV = "%s - Volume Display Green Channel";
formatSpecRV = "%s - Volume Display Red Channel";
VGhist_Header = sprintf(formatSpecGV,name);
VRhist_Header = sprintf(formatSpecRV,name);

%show the green volumes pixel values via histogram for Otsu's method and threshold
f = figure();
subplot(2,1,1);
[gcounts,gx] = imhist(green_volume,16);
stem(gx,gcounts);

title(Ghist_Header);
greenTherhold = otsuthresh(gcounts);
dim = [.5 .6 .3 .3];
Green_threshold_String = "Green Threshold Used: %f";
ThreshPrintG = sprintf(Green_threshold_String,greenTherhold);
annotation('textbox',dim,'String',ThreshPrintG,'FitBoxToText','on');


%show the red volumes pixel values via histogram for Otsu's method and threshold
subplot(2,1,2); 
[rcounts,rx] = imhist(red_volume,16);
stem(rx,rcounts);
title(Rhist_Header);
redThreshold = otsuthresh(rcounts);

dim = [.5 .1 .3 .3];
Red_threshold_String = "Red Threshold Used: %f";
ThreshPrintR = sprintf(Red_threshold_String,redThreshold);
annotation('textbox',dim,'String',ThreshPrintR,'FitBoxToText','on');

%create 3D binary mask from threshold determined by Otsu's method
gBW = imbinarize(green_volume,greenTherhold);
rBW = imbinarize(red_volume,redThreshold);

%Save binary masks for viewing post processing  
save(name,'gBW','rBW','green_volume','red_volume','greenTherhold','redThreshold');

%display 3D volume of green volume using labelvolshow and threshold
%grayscale values using the binary mask created using Otsu's method. 
ViewPnl = uipanel(figure,'Title',VGhist_Header);
hg = labelvolshow(im2double(gBW),green_volume,'BackgroundColor','w','VolumeThreshold',greenTherhold,'Parent',ViewPnl);
hg.LabelVisibility(2,:) = 0;
hg.VolumeOpacity = 1.0;


%display 3D volume of red volume using labelvolshow and threshold
%grayscale values using the binary mask created using Otsu's method. 
ViewPn2 = uipanel(figure,'Title',VRhist_Header);
hr = labelvolshow(im2double(rBW),red_volume,'BackgroundColor','w','VolumeThreshold',redThreshold,'Parent',ViewPn2);
hr.LabelVisibility(2,:) = 0;
hr.VolumeOpacity = 1.0;

%use regionprops for information extraction
Gstats = regionprops3(gBW,'Volume');
Rstats = regionprops3(rBW,'Volume');

%SUM THE TOTAL VOLUMES indentified using regionprops and the binary volume 
GVOLUME = sum(Gstats.Volume);
RVOLUME = sum(Rstats.Volume);
%get red to green ration
Volume_ratio_R_G = RVOLUME/GVOLUME;
%rename mask to something people will understand
GreenMask = gBW;
RedMask = rBW;
end