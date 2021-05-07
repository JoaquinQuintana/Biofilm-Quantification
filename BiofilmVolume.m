%% The LC3B Tandem Puncta Quantification 

%Code requires bioformats MATLAB Toolbox and MATLAB version R2021a or
%higher
%% Creator

% Created by: Joaquin Quintana(last modified: 2021-05-06)      
% Emial: Joaquin.Quintana@Colorado.edu
%% Details

% The script is designed to quantify Biofilm volumes. The biofilms should 
% be stained with the common live cell/dead cell 
% staining kit, i.e, Syto 9 and propidium iodide, respectively. Code
% assumes that the biofilms are tiffs and stored as z-stacks.  
% 
% Note: Dye labeling and fluorescence with Syto9 and propidium iodide vary 
% by strain,concentrations used, and environmental conditions. It is the 
% responsibility of the domain researcher and analysist to determine labeling
% concentrations for their dyes and validate results using other methods.
%
% Briefly, the code expects users to have 16-bit images, tif format, with 
% two channels interleaved. The code will deinterleave the PI and Syto9 
% channels from the multidimensional tiff stack and perform Otsu’s method on 
% each channel to determine a threshold. The thresholds determined are used 
% to display the volume using MATLABs labelvolshow and to compute the number 
% of voxels in the deinterleaved channels, this is, PI and Syto 9,
% respectively.

%% clear and close everything 
clc;
clear;
close all;
%% Ask user if they would like to use auto thresholding or manual 
[thresholdChoice,UserInputs] = userInputs();
% Open file explorer so the user can navigate to the in directory
inDir = uigetdir();
%create image data store 
imds = imageDatastore(inDir,...
'IncludeSubfolders',true,'FileExtensions','.tif','LabelSource','foldernames');
imds_NumerOfFiles = size(imds.Files(),1);

%% Initialize data storage
S = struct ;
% Initialize fields for data storage
S.GreenMaskVolume = [];
S.RedMaskVolume = [] ;
S.TotalVolume = [];
S.RedGreenRatio = [] ;
S.FileName = [];
S.Green_Thresh = [];
S.Red_Thresh = [];

%% Start processing images 
for ii = 1:imds_NumerOfFiles
% open tiff stack using bfopen. This function is from Bioformats 
img = bfopen(imds.Files{ii,:});
%Get file parts from bfopen
[pathstr,name] = fileparts(imds.Files{ii,:});
%get num of slices in tiff stack
number_of_image = size(img{1,1},1);
%determine the size of each image in stack. They are assumed to have same
%x,y dimensions.
plane_dimensions = size(img{1,1}{1,1}); 

%prealloacte some array space for volume
Volume = zeros([plane_dimensions,number_of_image],'double');

%Flat field correct images and place all data into array     
for i = 1:number_of_image
Volume(:,:,i) = im2double(imflatfield(img{1,1}{i,1},100));
end

%deinterleave red and green channels 
gV = Volume(:,:,1:2:end);
rV = Volume(:,:,2:2:end);

%clear orginal img and Volume as they are no longer needed
clear img Volume; 

%use manual or global threshold (Otsu's method); input from userIputs
%use manual threshold if user input is one
if thresholdChoice{1,1} == '1'
[GVOLUME,RVOLUME,Volume_ratio_R_G,GreenMask, RedMask,greenTherhold,redThreshold] = manual_thresh(gV,rV,str2double(UserInputs{1,1}),str2double(UserInputs{2,1}),name);
else
%use otsu's method if input is 2
[GVOLUME,RVOLUME,Volume_ratio_R_G,GreenMask, RedMask,greenTherhold,redThreshold] = Otsu_thresh(gV,rV,name);
end
%% Export results in structures 
    S(ii).GreenMaskVolume = GVOLUME;
    S(ii).RedMaskVolume = RVOLUME ; 
    S(ii).TotalVolume = GVOLUME + RVOLUME;
    S(ii).RedGreenRatio = Volume_ratio_R_G ;
    S(ii).FileName = name ;
    S(ii).Green_Thresh = greenTherhold; 
    S(ii).Red_Thresh  = redThreshold;
%% Convert results from struct to table
T = struct2table(S);
end
%print results to the command window
T