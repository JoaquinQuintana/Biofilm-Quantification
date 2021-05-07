function DisplayVolumes(MATLAB_FILE)
% Function displays the 3D volume results created by the function 
% BiofilmVolume.m. The volumes created in BiofilmVolume are saved buy the 
% function as .mat files. 
%
% BiofilmVolume saves the results from each volume processed as the same
% fileName that was used when the image is passed into the function. The 
% results of the process are saved as a .mat file and can be viewed using 
% this function by passing the .mat file, this is fileName.mat, to the
% function as a string. 

load(MATLAB_FILE);
%display volumes

%display green volume using threshold used in processing 
hg = labelvolshow(im2double(gBW),green_volume,'BackgroundColor','w','VolumeThreshold',greenTherhold);
hg.LabelVisibility(2,:) = 0;
hg.VolumeOpacity = 1.0;

%display red volume using threshold used in processing 
figure();
hr = labelvolshow(im2double(rBW),red_volume,'BackgroundColor','w','VolumeThreshold',redThreshold);
hr.LabelVisibility(2,:) = 0;
hr.VolumeOpacity = 1.0;
end
