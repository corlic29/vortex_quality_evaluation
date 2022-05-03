clear all
clc

%% Vortex_quality_evaluation
%{
Scripts aim to evaluate optical vortex quality by the inspection of its
intensity distribution.

Authors: Mateusz Szatkowski, Brandon Norton, Rosario Porras - Aguilar
Contact: mateusz.szatkowski@pwr.edu.pl
%}

%{
Script additionally uses functions:

intersections
Douglas Schwarz (2022). Fast and Robust Curve Intersections (https://www.mathworks.com/matlabcentral/fileexchange/11837-fast-and-robust-curve-intersections), MATLAB Central File Exchange. Retrieved January 20, 2022.

&
rotateAround
Jan Motl (2022). Rotate an image around a point (https://www.mathworks.com/matlabcentral/fileexchange/40469-rotate-an-image-around-a-point), MATLAB Central File Exchange. Retrieved January 20, 2022.
%}

%{
The desired doughnut_ratio value can be described by

desired_doughnut_ratio=1.608*abs(m)^0.5102-0.7913
where m denotes the input vortex topological charge

%}

%{
User can specify the number of profiles taken into account by modifing this
parameter:
no_of_rotations=2;

Where no. of evaluated profiles is no_of_rotations * 2. 
In the default scenario, vortex is evaluated across 4 profiles.
%}
%% Load image
[FileName,PathName] = uigetfile({'*.png';'*.jpg'; '*.bmp'; }, '.bmp','Select file','Multiselect','off');


I=im2double(imread([PathName FileName]));
I=imadjust(I);

%% Point out the vortex center
figure()
imagesc(I);
axis square
[vortex_point_y, vortex_point_x]= ginput(1);
close()

vortex_point_x=round(vortex_point_x);
vortex_point_y=round(vortex_point_y);

%% Image processing (optional)
%{
%I=rgb2gray(im2double(imread([PathName strjoin(FileName(z))])));
I=mat2gray(im2double(imread([PathName strjoin(FileName)])));
H = fspecial('disk',3);
%I = imfilter(I,H,'replicate');
%I = imadjust(I);
%imwrite(I,[PathName strjoin(FileName(z)) '_adjusted.bmp'])
%}

%% Quality inspection
%Eccentricity
[LG_parameters] = Get_LG_parameters_manual_2(I,vortex_point_x, vortex_point_y);
eccentricity=LG_parameters(1)

%x and y axes
[peaks_parameters1] = Get_peaks_parameters_manual_2(I,vortex_point_x, vortex_point_y);

%Diagonal axes
I2=rotateAround(I,vortex_point_y,vortex_point_x,45);
[peaks_parameters2] = Get_peaks_parameters_manual_2(I2,vortex_point_x, vortex_point_y);

%Mean values
peak_to_valley=mean([peaks_parameters1(1),peaks_parameters2(1)],'all')
peaks_difference=mean([peaks_parameters1(2),peaks_parameters2(2)],'all')
doughnut_ratio=mean([peaks_parameters1(3),peaks_parameters2(3)],'all')

close all

%% Results
results=[LG_parameters, peak_to_valley, peaks_difference, doughnut_ratio];

writematrix(results, [PathName FileName '.txt']);

%%
no_of_rotations=2;
rotation_angle=0:90/no_of_rotations:90;

for i=1:1:length(rotation_angle)-1;
I=rotateAround(I,vortex_point_y,vortex_point_x,rotation_angle(i));
%% Quality inspection
%Eccentricity
[LG_parameters] = Get_LG_parameters_manual_2(I,vortex_point_x, vortex_point_y);
eccentricity(i)=LG_parameters(1);

%x and y axes
[peaks_parameters1] = Get_peaks_parameters_manual_2(I,vortex_point_x, vortex_point_y);

%Mean values
peak_to_valley(i)=peaks_parameters1(1);
peaks_difference(i)=peaks_parameters1(2);
doughnut_ratio(i)=peaks_parameters1(3);

close all
end

Eccentricity=mean(eccentricity(:));
PV=mean(peak_to_valley(:));
PD=mean(peaks_difference(:));
R=mean(doughnut_ratio(:));

results=[Eccentricity, PV, PD, R];
