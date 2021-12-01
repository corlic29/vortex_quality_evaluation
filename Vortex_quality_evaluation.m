clear all
clc

%% Vortex_quality_evaluation
%{
Scripts aim to evaluate optical vortex quality by the inspection of its
intensity distribution.

Authors: Mateusz Szatkowski, Brandon Norton, Rosario Porras - Aguilar
Contact: mateusz.szatkowski@pwr.edu.pl
%}

%% Load image
[FileName,PathName] = uigetfile({'*.jpg'; '*.bmp';}, '.bmp','Select file','Multiselect','off');

I=im2double(imread([PathName FileName]));
%I=imadjust(I);

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
I = imfilter(I,H,'replicate');
I = imadjust(I);
imwrite(I,[PathName strjoin(FileName(z)) '_adjusted.bmp'])
%}


%% Quality inspection
[LG_parameters] = Get_LG_parameters_manual_2(I,vortex_point_x, vortex_point_y);
eccentricity=LG_parameters(1)

[peaks_parameters] = Get_peaks_parameters_manual_2(I,vortex_point_x, vortex_point_y);
peak_to_valley=peaks_parameters(1)
peaks_difference=peaks_parameters(2)
proportions=peaks_parameters(3)

close all

results=[LG_parameters, peaks_parameters];



