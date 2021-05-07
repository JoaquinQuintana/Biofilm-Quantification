# Biofilm-Quantification
MATLAB Code for 3D volume quantification of bacterial biofilms

Code requires bioformats MATLAB Toolbox and MATLAB version R2021a or
higher.

The script is designed to quantify Biofilm volumes. The biofilms should 
be stained with the common live cell/dead cell 
staining kit, i.e, Syto 9 and propidium iodide, respectively. Code
assumes that the biofilms are tiffs and stored as z-stacks.  

Note: Dye labeling and fluorescence with Syto9 and propidium iodide vary 
by strain,concentrations used, and environmental conditions. It is the 
responsibility of the domain researcher and analysist to determine labeling
concentrations for their dyes and validate results using other methods.

Briefly, the code expects users to have 16-bit images, tif format, with 
two channels interleaved. The code will deinterleave the PI and Syto9 
channels from the multidimensional tiff stack and perform Otsu’s method on 
each channel to determine a threshold. The thresholds determined are used 
to display the volume using MATLABs labelvolshow and to compute the number 
of voxels in the deinterleaved channels, this is, PI and Syto 9,
respectively.
